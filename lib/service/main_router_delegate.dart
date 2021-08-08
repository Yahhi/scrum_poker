import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/page/onboarding.dart';
import 'package:scrum_poker/page/page_404.dart';
import 'package:scrum_poker/page/people_details.dart';
import 'package:scrum_poker/page/people_editable.dart';
import 'package:scrum_poker/page/people_list.dart';
import 'package:scrum_poker/page/project_editable.dart';
import 'package:scrum_poker/page/projects_list.dart';
import 'package:scrum_poker/page/settings_page.dart';
import 'package:scrum_poker/page/splash_page.dart';
import 'package:scrum_poker/page/task_details.dart';
import 'package:scrum_poker/page/task_editable.dart';
import 'package:scrum_poker/page/tasks_list.dart';
import 'package:scrum_poker/page/voting_offline.dart';
import 'package:scrum_poker/service/settings.dart';
import 'package:scrum_poker/state/disposable_state.dart';
import 'package:scrum_poker/state/people_state.dart';
import 'package:scrum_poker/state/person_edit_state.dart';
import 'package:scrum_poker/state/project_edit_state.dart';
import 'package:scrum_poker/state/project_list_state.dart';
import 'package:scrum_poker/state/task_edit_state.dart';
import 'package:scrum_poker/state/voting_offline_state.dart';

import 'main_route_path.dart';
import 'navigator_actions.dart';

class MainRouterDelegate extends RouterDelegate<MainRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> implements NavigatorActions {
  MainRouterDelegate(this.navigatorKey);

  ProjectListState get _projectListState => GetIt.instance<ProjectListState>();
  PeopleState get _peopleState => GetIt.instance<PeopleState>();

  @override
  MainRoutePath? currentConfiguration;

  Project? _selectedProject;
  Task? _selectedTask;
  Person? _selectedPerson;

  DisposableState? _state;
  void _setEditState(DisposableState state) {
    _state?.setReadyToDispose();
    attachCloseAndDispose(state);
    _state = state;
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Settings get _settings => GetIt.instance<Settings>();

  void _decideWhichScreenIsFirst() {
    //TODO можно еще логин сюда запихать и дождаться полной загрузки
    if (_settings.didOnboarding) {
      setNewRoutePath(MainRoutePath.projectsList());
    } else {
      setNewRoutePath(MainRoutePath.onboarding());
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('current router config: $currentConfiguration');
    if (currentConfiguration == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) => _decideWhichScreenIsFirst());
      return Navigator(
        key: navigatorKey,
        pages: const [
          MaterialPage(
            key: ValueKey('SplashPage'),
            child: SplashPage(),
          )
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          currentConfiguration = MainRoutePath.projectsList();
          notifyListeners();
          return true;
        },
      );
    }

    final pages = <Page>[];
    for (var pageInfo in currentConfiguration!.pages) {
      final page = _selectPage(pageInfo);
      if (page == null) {
        // there is error in path. 404 should be shown
        pages.add(const MaterialPage(
          key: ValueKey('404Page'),
          child: Page404(),
        ));
        break;
      }
      pages.add(page);
    }
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentConfiguration = currentConfiguration!.removeLastPart();
        notifyListeners();
        return true;
      },
    );
  }

  MaterialPage? _selectPage(PageData pageData) {
    switch (pageData.pageType) {
      case PageType.projectList:
        return MaterialPage(
          child: ProjectsListPage(
            _projectListState,
            navigatorActions: this,
          ),
        );
      case PageType.projectEdit:
        _selectedProject = _projectListState.findProjectById(pageData.param);
        final state = ProjectEditState(editedProject: _selectedProject);
        _setEditState(state);
        return MaterialPage(child: ProjectEditablePage(state));
      case PageType.taskList:
        _selectedProject = _projectListState.findProjectById(pageData.param);
        if (_selectedProject == null) {
          return null;
        } else {
          return MaterialPage(child: TasksList(_selectedProject!, navigatorActions: this));
        }
      case PageType.taskEdit:
        _selectedTask = _selectedProject?.findTaskById(pageData.param);
        if (_selectedProject == null) {
          return null;
        } else {
          final state = TaskEditState(project: _selectedProject!, editedTask: _selectedTask);
          _setEditState(state);
          return MaterialPage(child: TaskEditablePage(state));
        }
      case PageType.taskVote:
        if (_selectedTask == null || _selectedProject == null) {
          return null;
        } else {
          return MaterialPage(child: VotingOfflinePage(VotingOfflineState(_selectedTask!, _selectedProject!)));
        }
      case PageType.taskStats:
        _selectedTask = _selectedProject?.findTaskById(pageData.param);
        if (_selectedTask == null || _selectedProject == null) {
          return null;
        } else {
          return MaterialPage(
            child: TaskDetailsPage(
              _selectedTask!,
              project: _selectedProject!,
              navigatorActions: this,
            ),
          );
        }
      case PageType.peopleList:
        return MaterialPage(
          child: PeopleListPage(
            state: _peopleState,
            navigatorActions: this,
          ),
        );
      case PageType.peopleEdit:
        PersonEditState state;
        if (pageData.param == null) {
          state = PersonEditState();
        } else {
          _selectedPerson = _peopleState.findPersonById(pageData.param!);
          state = PersonEditState(editedPerson: _selectedPerson);
        }
        _setEditState(state);
        return MaterialPage(
          child: PeopleEditablePage(
            state,
          ),
        );
      case PageType.peopleDetails:
        if (pageData.param == null) {
          return null;
        } else {
          _selectedPerson = _peopleState.findPersonById(pageData.param!);
        }
        return _selectedPerson == null
            ? null
            : MaterialPage(
                child: PeopleDetailsPage(_selectedPerson!),
              );
      case PageType.settings:
        return const MaterialPage(
          key: ValueKey('SettingsPage'),
          child: SettingsPage(),
        );
      case PageType.splash:
        return const MaterialPage(
          key: ValueKey('SplashPage'),
          child: SplashPage(),
        );
      case PageType.page404:
        return const MaterialPage(
          key: ValueKey('404Page'),
          child: Page404(),
        );
      case PageType.onboarding:
        return const MaterialPage(
          key: ValueKey('OnboardingPage'),
          child: OnboardingPage(),
        );
    }
  }

  void attachCloseAndDispose(DisposableState state) {
    StreamSubscription? subscription;
    subscription = state.stateStatus.listen((StateStatus event) {
      if (event == StateStatus.actionDone) {
        setNewRoutePath(currentConfiguration!.removeLastPart());
      } else if (event == StateStatus.canBeDisposed) {
        subscription?.cancel();
        Future.delayed(const Duration(seconds: 1)).then((_) {
          state.dispose();
        });
      }
    });
  }

  @override
  Future<void> setNewRoutePath(MainRoutePath configuration) async {
    currentConfiguration = configuration;
    notifyListeners();
  }

  @override
  void editPerson({Person? person}) {
    if (person == null) {
      setNewRoutePath(MainRoutePath.personAdd());
    } else {
      setNewRoutePath(MainRoutePath.personEdit(person.id!));
    }
  }

  @override
  void editProject({Project? project}) {
    if (project == null) {
      setNewRoutePath(MainRoutePath.projectAdd());
    } else {
      setNewRoutePath(MainRoutePath.projectEdit(project.id));
    }
  }

  @override
  void editTask(Task? task, Project parentProject) {
    if (task == null) {
      setNewRoutePath(MainRoutePath.taskAdd(parentProject.id));
    } else {
      setNewRoutePath(MainRoutePath.taskEdit(parentProject.id, task.id!));
    }
  }

  @override
  void openPeopleList() {
    setNewRoutePath(MainRoutePath.personList());
  }

  @override
  void openPersonDetails(Person person) {
    setNewRoutePath(MainRoutePath.personDetails(person.id!));
  }

  @override
  void openSettings() {
    setNewRoutePath(MainRoutePath.settings());
  }

  @override
  void openTaskDetails(Task task, Project parentProject) {
    setNewRoutePath(MainRoutePath.taskDetails(parentProject.id, task.id!));
  }

  @override
  void openTaskList(Project project) {
    setNewRoutePath(MainRoutePath.taskList(project.id));
  }

  @override
  void openVoting(Task task, Project parentProject) {
    setNewRoutePath(MainRoutePath.taskVote(parentProject.id, task.id!));
  }
}
