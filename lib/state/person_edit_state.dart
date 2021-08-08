import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/state/network_state.dart';
import 'package:mobx/mobx.dart';
import 'package:scrum_poker/state/people_state.dart';

import 'disposable_state.dart';

part 'person_edit_state.g.dart';

class PersonEditState = _PersonEditState with _$PersonEditState;

abstract class _PersonEditState extends NetworkState with DisposableState, Store {
  _PersonEditState({this.editedPerson}) {
    if (editedPerson == null) {
      nameController = TextEditingController();
    } else {
      nameController = TextEditingController(text: editedPerson!.name ?? '');
      imageAddress = editedPerson!.imageAddress;
    }
    nameController.addListener(() {
      name = nameController.text;
    });
  }

  /// if person is edited this field contains initial value
  final Person? editedPerson;

  late TextEditingController nameController;

  bool get isEditing => editedPerson != null;

  @observable
  String? name;

  @observable
  String? imageAddress;

  /// allows UI to save data (empty name is inappropriate)
  @computed
  bool get isSaveAvailable => (name?.length ?? 0) > 0;

  /// this state is required to add result to the main list
  PeopleState get _peopleState => GetIt.instance<PeopleState>();

  /// this repository is responsible for long term storage
  PeopleRepository get _repository => GetIt.instance.get<PeopleRepository>();

  /// saves or edits person
  ///
  /// Main action of the state
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
    final previousStateName = editedPerson!.name;
    final previousStateImage = editedPerson!.imageAddress;
    editedPerson!.name = name;
    editedPerson!.imageAddress = imageAddress;
    setStateActionDone();
    final result = await _repository.updatePerson(editedPerson!);
    if (result.isSuccess && result.data!) {
      setReadyToDispose();
    } else {
      editedPerson!.name = previousStateName;
      editedPerson!.imageAddress = previousStateImage;
      error = result.errorDescription; //TODO заменить на EventBus
    }
  }

  @action
  Future<void> _create() async {
    final result = await _repository.addPerson(Person(name: name, imageAddress: imageAddress));
    if (result.isSuccess) {
      _peopleState.addPersonToList(result.data!);
      setStateActionDone();
      setReadyToDispose();
    } else {
      error = result.errorDescription;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
