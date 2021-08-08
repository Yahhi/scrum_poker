import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/service/constants.dart';
import 'package:scrum_poker/state/task_edit_state.dart';
import 'package:scrum_poker/widget/common_text_field.dart';

class TaskEditablePage extends StatelessWidget {
  const TaskEditablePage(
    this.state, {
    Key? key,
  }) : super(key: key);

  final TaskEditState state;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(state.isEditing ? 'Edit task' : 'Add task'),
        ),
        body: Padding(
          padding: Constants.bodyPaddding,
          child: Column(
            children: [
              CommonTextField(label: 'Title', controller: state.titleController),
              const SizedBox(height: Constants.fieldVerticalSpace),
              Expanded(
                child: CommonTextField(
                  label: 'Description',
                  controller: state.descriptionController,
                  maxLines: null,
                ),
              ),
              const SizedBox(height: Constants.fieldVerticalSpace * 5),
              if (state.project.usageType == UsageType.personal)
                Row(
                  children: [
                    Expanded(
                      child: CommonTextField(
                        label: 'Estimation',
                        controller: state.estimationController,
                      ),
                    ),
                    const SizedBox(
                      width: Constants.fieldVerticalSpace,
                    ),
                    const Expanded(
                      child: Text('SP'),
                    ),
                  ],
                ),
            ],
          ),
        ),
        floatingActionButton: Observer(
            builder: (_) => state.isSaveAvailable
                ? FloatingActionButton(
                    onPressed: state.save,
                    child: const Icon(Icons.save),
                  )
                : const SizedBox.shrink()),
      );
}
