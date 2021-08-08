import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/service/constants.dart';
import 'package:scrum_poker/state/project_edit_state.dart';
import 'package:scrum_poker/widget/common_text_field.dart';

class ProjectEditablePage extends StatelessWidget {
  const ProjectEditablePage(
    this.state, {
    Key? key,
  }) : super(key: key);

  final ProjectEditState state;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(state.isEditing ? 'Edit project' : 'Add project'),
        ),
        body: Padding(
          padding: Constants.bodyPaddding,
          child: Column(
            children: [
              CommonTextField(label: 'Title', controller: state.titleController),
            ],
          ),
        ),
        floatingActionButton: Observer(
          builder: (_) => state.isSaveAvailable
              ? FloatingActionButton(
                  onPressed: state.save,
                  child: const Icon(Icons.save),
                )
              : const SizedBox.shrink(),
        ),
      );
}
