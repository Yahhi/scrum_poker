import 'package:flutter/material.dart';
import 'package:scrum_poker/model/task.dart';
import 'package:scrum_poker/widget/slide_actions_wrapper.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem(
    this.task, {
    Key? key,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  final Task task;
  final ValueChanged<Task> onEdit;
  final ValueChanged<Task> onDelete;
  final ValueChanged<Task> onTap;

  @override
  Widget build(BuildContext context) => SlideActionsWrapper(
        onEdit: () => onEdit(task),
        onDelete: () => onDelete(task),
        onTap: () => onTap(task),
        child: ListTile(
          title: Text(
            task.readableTitle,
          ),
          subtitle: task.description == null
              ? null
              : Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      );
}
