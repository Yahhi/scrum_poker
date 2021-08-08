import 'dart:math';

import 'package:scrum_poker/data/mock_data.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/repository_result.dart';
import 'package:scrum_poker/service/repository_interface.dart';

class LocalProjectRepository extends ProjectRepository {
  @override
  Future<RepositoryResult<Project>> addProject(String title) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(
        data: Project(id: Random().nextInt(1000).toString(), title: title));
  }

  @override
  Future<RepositoryResult<bool>> attachUser(
      String projectId, String personId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<bool>> deleteProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<List<Project>>> fetchProjects() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(data: mockProjects);
  }

  @override
  Future<RepositoryResult<bool>> removeUser(
      String projectId, String personId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<bool>> updateProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return RepositoryResult(data: true);
  }
}
