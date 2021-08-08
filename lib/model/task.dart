import 'package:mobx/mobx.dart';

part 'task.g.dart';

class Task = _Task with _$Task;

abstract class _Task with Store {
  _Task({this.id, this.title, this.description, this.estimation = 0});

  final String? id;
  @observable
  String? title;
  @computed
  String get readableTitle => title ?? 'untitled';

  final String? description;

  final int estimation;

  Task copyWith({String? id, String? description, int? estimation}) => Task(id: id ?? this.id, title: title, description: description ?? this.description, estimation: estimation ?? this.estimation);
}
