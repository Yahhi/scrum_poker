import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/service/navigator_actions.dart';
import 'package:scrum_poker/state/project_list_state.dart';
import 'package:scrum_poker/widget/no_items.dart';
import 'package:scrum_poker/widget/project_list_item.dart';

class ProjectsListPage extends StatelessWidget {
  const ProjectsListPage(
    this.state, {
    Key? key,
    required this.navigatorActions,
  }) : super(key: key);

  final ProjectListState state;
  final NavigatorActions navigatorActions;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Projects'),
          actions: [
            IconButton(onPressed: navigatorActions.openPeopleList, icon: const Icon(Icons.people)),
            IconButton(onPressed: navigatorActions.openSettings, icon: const Icon(Icons.settings)),
          ],
        ),
        body: Observer(
          builder: (_) => state.projects.isEmpty
              ? const NoItems(
                  title: 'There is no projects yet',
                  subtitle: 'Please, add some projects to make this cat work',
                )
              : ListView.builder(
                  itemCount: state.projects.length,
                  itemBuilder: (context, index) => ProjectListItem(
                    state.projects[index],
                    state: state,
                    onEdit: (project) => navigatorActions.editProject(project: project),
                    onTap: (project) => navigatorActions.openTaskList(project),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => navigatorActions.editProject,
        ),
      );
}
