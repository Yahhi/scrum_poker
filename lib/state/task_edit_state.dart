import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/state/disposable_state.dart';
import 'package:scrum_poker/state/network_state.dart';

part 'task_edit_state.g.dart';

class TaskEditState = _TaskEditState with _$TaskEditState;

abstract class _TaskEditState extends NetworkState with DisposableState, Store {
  _TaskEditState({required this.project, this.editedTask}) {
    if (editedTask == null) {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      estimationController = TextEditingController();
    } else {
      titleController = TextEditingController(text: editedTask!.title ?? '');
      descriptionController = TextEditingController(text: editedTask!.description);
      estimationController = TextEditingController(text: editedTask!.estimation.toString());
    }
    titleController.addListener(() {
      title = titleController.text;
    });
  }

  final Project project;
  final Task? editedTask;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController estimationController;

  bool get isEditing => editedTask != null;

  @observable
  String? title;

  /// allows UI to save data (empty title is inappropriate)
  @computed
  bool get isSaveAvailable => (title?.length ?? 0) > 0;

  TaskRepository get _repository => GetIt.instance.get<TaskRepository>();

  @action
  Future<void> save() async {
    if (isEditing) {
      await _update();
    } else {
      await _create();
    }
  }

  @action
  Future<void> _update() async {
    // обновляем сразу, если неудачно - сообщаем через EventBus
    final estimation = int.tryParse(estimationController.text) ?? 0;
    final updatedTask = editedTask!.copyWith(description: descriptionController.text, estimation: estimation);
    updatedTask.title = title;
    final index = project.tasks.indexOf(editedTask);
    project.tasks[index] = updatedTask;
    setStateActionDone();

    final result = await _repository.updateTask(project.id, updatedTask);
    if (result.isSuccess && result.data!) {
      setReadyToDispose();
    } else {
      project.tasks[index] = editedTask!;
      error = result.errorDescription; //TODO заменить на EventBus
    }
  }

  @action
  Future<void> _create() async {
    isLoading = true;
    final estimation = int.tryParse(estimationController.text) ?? 0;
    final result = await _repository.addTask(project.id, Task(title: title, description: descriptionController.text, estimation: estimation));
    isLoading = false;
    if (result.isSuccess) {
      project.tasks.add(result.data!);
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
