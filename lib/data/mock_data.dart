import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';

final appUser = Person(id: 'p1', name: 'App user');
final vasiliy = Person(id: 'p2', name: 'Vasiliy');
final alisa = Person(id: 'p3', name: 'Alisa');

final mockPeople = [
  appUser,
  vasiliy,
  alisa,
];

final tasksInProject = [
  Task(title: 'set up environment', estimation: 2),
  Task(title: 'Connect common libraries', estimation: 1),
  Task(
      title: 'Modify some code',
      description: 'Create a simple login form UI',
      estimation: 2),
  Task(
      title: 'Share project on github',
      description: 'Share it and describe what is inside the repo',
      estimation: 1),
];

final mockProjects = [
  Project(id: '1', users: [appUser, vasiliy])
    ..title = 'Example Flutter project'
    ..tasks.addAll(tasksInProject),
  Project(id: '2', users: [appUser, alisa])..title = 'Side project',
];
