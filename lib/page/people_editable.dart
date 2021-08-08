import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrum_poker/service/constants.dart';
import 'package:scrum_poker/state/person_edit_state.dart';
import 'package:scrum_poker/widget/common_text_field.dart';
import 'package:scrum_poker/widget/person_avatar.dart';

class PeopleEditablePage extends StatelessWidget {
  const PeopleEditablePage(this.state, {Key? key}) : super(key: key);

  final PersonEditState state;

  Future<void> _openImageSelection() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) {
      return;
    }
    state.imageAddress = file.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(state.isEditing ? 'Edit person' : 'Add person'),
        ),
        body: Padding(
          padding: Constants.bodyPaddding,
          child: Column(
            children: [
              PersonAvatar(
                state.editedPerson,
                onChangeAction: _openImageSelection,
                avatarRadius: 50,
              ),
              const SizedBox(height: Constants.fieldVerticalSpace),
              CommonTextField(
                label: 'Name',
                controller: state.nameController,
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
              : const SizedBox.shrink(),
        ),
      );
}
