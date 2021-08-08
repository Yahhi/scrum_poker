import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scrum_poker/service/local_project_repository.dart';
import 'package:scrum_poker/service/local_storage/people_repository.dart';
import 'package:scrum_poker/service/local_storage/task_repository.dart';
import 'package:scrum_poker/service/main_route_information_parser.dart';
import 'package:scrum_poker/service/main_router_delegate.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/service/settings.dart';
import 'package:scrum_poker/state/people_state.dart';
import 'package:scrum_poker/state/project_list_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<PeopleRepository>(LocalPeopleRepository());
  GetIt.instance.registerSingleton<ProjectRepository>(LocalProjectRepository());
  GetIt.instance.registerSingleton<TaskRepository>(LocalTaskRepository());
  GetIt.instance.registerSingleton<Settings>(Settings());
  GetIt.instance.registerSingleton<ProjectListState>(ProjectListState());
  GetIt.instance.registerSingleton<PeopleState>(PeopleState());
  final _key = GlobalKey<NavigatorState>();
  runApp(MyApp(_key));
}

class MyApp extends StatelessWidget {
  const MyApp(this.navigatorKey, {Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Scrum Poker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: MainRouterDelegate(navigatorKey),
      routeInformationParser: MainRouteInformationParser(),
    );
  }
}
