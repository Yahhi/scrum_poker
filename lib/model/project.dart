import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/task.dart';

part 'project.g.dart';

class Project = _Project with _$Project;

abstract class _Project with Store {
  _Project({DateTime? customCreation, List<Person>? users, this.title, required this.id})
      : created = customCreation ?? DateTime.now(),
        members = users ?? [];

  final String id;

  @observable
  String? title;
  @computed
  String get readableTitle => title ?? 'untitled';

  final List<Person> members;

  @observable
  ObservableList<Task> tasks = ObservableList();

  @computed
  int get tasksCount => tasks.length;

  @computed
  String get readableTasksCount => Intl.plural(
        tasksCount,
        zero: 'No tasks',
        one: '$tasksCount task',
        other: '$tasksCount tasks',
        name: 'task',
        args: [tasksCount],
      );

  @computed
  int get tasksTotalWeight => tasks.fold(0, (previousValue, element) => previousValue += element.estimation);

  final DateTime created;

  @observable
  UsageType usageType = UsageType.personal;

  @observable
  StorageType storageType = StorageType.localDatabase;

  Task? findTaskById(String? id) {
    if (id == null) {
      return null;
    }
    try {
      return tasks.firstWhere((element) => element.id == id);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

enum UsageType { personal, localTeam, remoteTeam }

enum StorageType { localDatabase, firebase, remoteServer }
