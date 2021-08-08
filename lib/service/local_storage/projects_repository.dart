import 'dart:math';

import 'package:scrum_poker/data/mock_data.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/service/repository_result.dart';

class LocalProjectRepository extends ProjectRepository {
  @override
  Future<RepositoryResult<Project>> addProject(String title) async {
    final project = Project(id: Random().nextInt(10000).toString(), title: title);
    mockProjects.add(project);
    return RepositoryResult(data: project);
  }

  @override
  Future<RepositoryResult<bool>> attachUser(String projectId, String personId) async {
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<bool>> deleteProject(Project project) async {
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<List<Project>>> fetchProjects() async {
    return RepositoryResult(data: mockProjects);
  }

  @override
  Future<RepositoryResult<bool>> removeUser(String projectId, String personId) async {
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<bool>> updateProject(Project project) async {
    return RepositoryResult(data: true);
  }
}
