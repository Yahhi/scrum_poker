import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/state/disposable_state.dart';
import 'package:scrum_poker/state/network_state.dart';
import 'package:mobx/mobx.dart';

part 'project_edit_state.g.dart';

class ProjectEditState = _ProjectEditState with _$ProjectEditState;

abstract class _ProjectEditState extends NetworkState with DisposableState, Store {
  _ProjectEditState({this.editedProject}) {
    if (editedProject == null) {
      titleController = TextEditingController();
    } else {
      titleController = TextEditingController(text: editedProject!.title ?? '');
    }
    titleController.addListener(() {
      title = titleController.text;
    });
  }

  final Project? editedProject;
  late TextEditingController titleController;

  bool get isEditing => editedProject != null;

  @observable
  String? title;

  /// allows UI to save data (empty title is inappropriate)
  @computed
  bool get isSaveAvailable => (title?.length ?? 0) > 0;

  ProjectRepository get _repository => GetIt.instance.get<ProjectRepository>();

  /// main action of the state. Saves data. During the process error can appear
  @action
  Future<void> save() async {
    if (isEditing) {
      // обновляем сразу, если неудачно - сообщаем через EventBus
      await _update();
    } else {
      isLoading = true;
      await _create();
      isLoading = false;
    }
  }

  @action
  Future<void> _update() async {
    final previousStateTitle = editedProject!.title;
    editedProject!.title = titleController.text;
    setStateActionDone();
    final result = await _repository.updateProject(editedProject!);
    if (result.isSuccess && result.data!) {
      setReadyToDispose();
    } else {
      editedProject!.title = previousStateTitle;
      error = result.errorDescription; //TODO заменить на EventBus
    }
  }

  @action
  Future<void> _create() async {
    final result = await _repository.addProject(titleController.text);
    if (result.isSuccess) {
      setStateActionDone();
      setReadyToDispose();
    } else {
      error = result.errorDescription;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
