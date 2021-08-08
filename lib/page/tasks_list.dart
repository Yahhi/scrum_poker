import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/navigator_actions.dart';
import 'package:scrum_poker/widget/no_items.dart';
import 'package:scrum_poker/widget/task_list_item.dart';

class TasksList extends StatelessWidget {
  const TasksList(
    this.project, {
    Key? key,
    required this.navigatorActions,
  }) : super(key: key);

  final Project project;
  final NavigatorActions navigatorActions;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(project.readableTitle)),
        body: Observer(
          builder: (_) {
            if (project.tasksCount == 0) {
              return const NoItems(
                title: 'No tasks',
                subtitle: 'Please, add some tasks to make this cat work',
              );
            } else {
              return ListView.builder(
                  itemCount: project.tasksCount,
                  itemBuilder: (context, index) => TaskListItem(project.tasks[index],
                      onEdit: (task) => navigatorActions.editTask(task, project),
                      onDelete: (task) => project.tasks.remove(task),
                      onTap: (task) => navigatorActions.openTaskDetails(task, project)));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => navigatorActions.editTask(null, project),
          child: const Icon(Icons.add),
        ),
      );
}
