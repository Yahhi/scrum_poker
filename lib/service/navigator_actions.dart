import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';

abstract class NavigatorActions {
  void openSettings();
  void editProject({Project? project});
  void openPeopleList();
  void editPerson({Person? person});
  void openPersonDetails(Person person);
  void openTaskList(Project project);
  void editTask(Task? task, Project parentProject);
  void openTaskDetails(Task task, Project parentProject);
  void openVoting(Task task, Project parentProject);
}
