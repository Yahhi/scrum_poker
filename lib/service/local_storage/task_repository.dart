import 'dart:math';

import 'package:scrum_poker/data/mock_data.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/service/repository_result.dart';

class LocalTaskRepository extends TaskRepository {
  @override
  Future<RepositoryResult<Task>> addTask(String projectId, Task task) async {
    return RepositoryResult(data: task.copyWith(id: Random().nextInt(1000).toString()));
  }

  @override
  Future<RepositoryResult<List<Task>>> fetchProjectTasks(String projectId) async {
    return RepositoryResult(data: mockProjects.firstWhere((element) => projectId == element.id).tasks);
  }

  @override
  Future<RepositoryResult<bool>> updateTask(String projectId, Task task) async {
    return RepositoryResult(data: true);
  }
}
