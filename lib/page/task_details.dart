import 'package:flutter/material.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/service/constants.dart';
import 'package:scrum_poker/service/navigator_actions.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage(this.task, {Key? key, required this.project, required this.navigatorActions}) : super(key: key);

  final Task task;
  final Project project;
  final NavigatorActions navigatorActions;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(task.readableTitle)),
        body: Padding(
          padding: Constants.bodyPaddding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description != null) ...[
                const Text('Description:'),
                const SizedBox(
                  height: Constants.fieldVerticalSpace,
                ),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: Constants.fieldVerticalSpace)
              ],
              if (task.estimation != 0) ...[
                const Text('Estimation:'),
                Text(
                  task.estimation.toString(),
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ],
          ),
        ),
        floatingActionButton: task.estimation == 0 && project.usageType != UsageType.personal
            ? FloatingActionButton(child: const Icon(Icons.how_to_vote), onPressed: () => navigatorActions.openVoting(task, project))
            : null,
      );
}
