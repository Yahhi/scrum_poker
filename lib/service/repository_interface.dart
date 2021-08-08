import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/service/repository_result.dart';

abstract class PeopleRepository {
  Future<RepositoryResult<List<Person>>> fetchKnownPeople();
  Future<RepositoryResult<Person>> addPerson(Person person);
  Future<RepositoryResult<bool>> updatePerson(Person person);
  Future<RepositoryResult<bool>> deletePerson(Person person);
}

abstract class ProjectRepository {
  Future<RepositoryResult<List<Project>>> fetchProjects();
  Future<RepositoryResult<Project>> addProject(String title);
  Future<RepositoryResult<bool>> updateProject(Project project);
  Future<RepositoryResult<bool>> deleteProject(Project project);
  Future<RepositoryResult<bool>> attachUser(String projectId, String personId);
  Future<RepositoryResult<bool>> removeUser(String projectId, String personId);
}

abstract class TaskRepository {
  Future<RepositoryResult<List<Task>>> fetchProjectTasks(String projectId);
  Future<RepositoryResult<Task>> addTask(String projectId, Task task);
  Future<RepositoryResult<bool>> updateTask(String projectId, Task task);
}
