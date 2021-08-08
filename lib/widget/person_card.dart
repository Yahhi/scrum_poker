import 'package:flutter/material.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/widget/person_avatar.dart';

/// Widget to show persons while voting. If persons are local we can select who will vote.
/// If there is network voting, we just receive results and can't select persons.
class PersonCard extends StatelessWidget {
  const PersonCard(this.person,
      {Key? key,
      this.vote = 0,
      this.isSelected = false,
      this.isVotingFinished = false,
      this.onSelect})
      : super(key: key);

  final Person person;
  final int vote;
  final bool isSelected;
  final bool isVotingFinished;
  final VoidCallback? onSelect;

  Widget _buildCard(BuildContext context) => Card(
        elevation: isSelected ? 8 : 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PersonAvatar(person),
            if (isVotingFinished) Text(vote.toString()),
            if (!isVotingFinished && vote == 0)
              const Icon(Icons.thumb_up_alt_rounded),
            if (!isVotingFinished && vote != 0)
              const Icon(Icons.thumb_up_alt_outlined),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => onSelect == null
      ? _buildCard(context)
      : InkWell(
          onTap: onSelect,
          child: _buildCard(context),
        );
}
