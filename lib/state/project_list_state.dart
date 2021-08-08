import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/state/network_state.dart';

part 'project_list_state.g.dart';

class ProjectListState = _ProjectListState with _$ProjectListState;

abstract class _ProjectListState extends NetworkState with Store {
  _ProjectListState() {
    _loadProjects();
  }

  @observable
  ObservableList<Project> projects = ObservableList();

  ProjectRepository get _repository => GetIt.instance.get<ProjectRepository>();

  @action
  Future<void> _loadProjects() async {
    isLoading = true;
    final result = await _repository.fetchProjects();
    if (result.isSuccess) {
      projects.addAll(result.data!);
    } else {
      error = result.errorDescription;
    }
    isLoading = false;
  }

  @action
  Future<void> deleteProject(Project project) async {
    final index = projects.indexOf(project);
    projects.removeAt(index);
    final result = await _repository.deleteProject(project);
    if (!result.isSuccess) {
      projects.insert(index, project);
      error = result.errorDescription;
    }
  }

  Project? findProjectById(String? id) {
    if (id == null) {
      return null;
    }
    try {
      return projects.firstWhere((element) => element.id == id);
    } catch (e) {
      debugPrint('No project found');
      return null;
    }
  }
}
