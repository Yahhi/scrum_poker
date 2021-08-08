import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/service/navigator_actions.dart';
import 'package:scrum_poker/state/people_state.dart';
import 'package:scrum_poker/widget/person_list_item.dart';

class PeopleListPage extends StatelessWidget {
  const PeopleListPage({Key? key, required this.state, required this.navigatorActions}) : super(key: key);

  final PeopleState state;
  final NavigatorActions navigatorActions;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('People')),
        body: Observer(
          builder: (_) => ListView.builder(
            itemCount: state.people.length,
            itemBuilder: (context, index) => PersonListItem(
              state.people[index],
              onTap: navigatorActions.openPersonDetails,
              onEdit: (person) => navigatorActions.editPerson(person: person),
              onDelete: state.deletePerson,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: navigatorActions.editPerson,
        ),
      );
}
