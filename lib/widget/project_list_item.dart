import 'package:flutter/material.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/state/project_list_state.dart';

import 'slide_actions_wrapper.dart';

class ProjectListItem extends StatelessWidget {
  const ProjectListItem(
    this.project, {
    required this.state,
    Key? key,
    required this.onEdit,
    required this.onTap,
  }) : super(key: key);

  final Project project;
  final ProjectListState state;
  final Function(Project) onEdit;
  final Function(Project) onTap;

  @override
  Widget build(BuildContext context) => SlideActionsWrapper(
        onDelete: () => state.deleteProject(project),
        onTap: () => onTap(project),
        onEdit: () => onEdit(project),
        child: ListTile(
          title: Text(project.readableTitle),
          subtitle: Text(project.readableTasksCount),
        ),
      );
}
