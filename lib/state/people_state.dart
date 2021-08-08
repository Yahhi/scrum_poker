import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/state/network_state.dart';

part 'people_state.g.dart';

class PeopleState = _PeopleState with _$PeopleState;

abstract class _PeopleState extends NetworkState with Store {
  _PeopleState() {
    _loadPeople();
  }

  @observable
  ObservableList<Person> people = ObservableList();

  PeopleRepository get _repository => GetIt.instance<PeopleRepository>();

  @action
  Future<void> _loadPeople() async {
    isLoading = true;
    final result = await _repository.fetchKnownPeople();
    if (result.isSuccess) {
      people.addAll(result.data!);
    } else {
      error = result.errorDescription;
    }
    isLoading = false;
  }

  @action
  Future<void> deletePerson(Person person) async {
    //TODO надо еще проверить, не участвует ли этот человек в каком-то проекте
    final index = people.indexOf(person);
    people.removeAt(index);
    final result = await _repository.deletePerson(person);
    if (!result.isSuccess) {
      people.insert(index, person);
      error = result.errorDescription;
    }
  }

  @action
  void addPersonToList(Person person) {
    people.add(person);
  }

  Person? findPersonById(String id) {
    try {
      return people.firstWhere((element) => element.id == id);
    } catch (e) {
      debugPrint('No project found');
      return null;
    }
  }
}
