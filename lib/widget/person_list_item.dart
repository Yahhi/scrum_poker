import 'package:flutter/material.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/widget/person_avatar.dart';
import 'package:scrum_poker/widget/slide_actions_wrapper.dart';

class PersonListItem extends StatelessWidget {
  const PersonListItem(this.person, {Key? key, required this.onEdit, required this.onDelete, required this.onTap}) : super(key: key);

  final Person person;
  final ValueChanged<Person> onEdit;
  final ValueChanged<Person> onDelete;
  final ValueChanged<Person> onTap;

  @override
  Widget build(BuildContext context) => SlideActionsWrapper(
        onEdit: () => onEdit(person),
        onDelete: () => onDelete(person),
        onTap: () => onTap(person),
        child: ListTile(
          leading: PersonAvatar(person),
          title: Text(
            person.readableName,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      );
}
