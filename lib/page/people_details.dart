import 'package:flutter/material.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/widget/person_avatar.dart';

class PeopleDetailsPage extends StatelessWidget {
  const PeopleDetailsPage(this.person, {Key? key}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Person info'),
        ),
        body: Column(
          children: [
            PersonAvatar(person),
            Text(person.readableName),
          ],
        ),
      );
}
