import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scrum_poker/service/constants.dart';
import 'package:scrum_poker/state/voting_offline_state.dart';
import 'package:scrum_poker/widget/person_card.dart';
import 'package:scrum_poker/widget/vote_selection_card.dart';

class VotingOfflinePage extends StatelessWidget {
  const VotingOfflinePage(
    this.state, {
    Key? key,
  }) : super(key: key);

  final VotingOfflineState state;

  void _saveAndClose(BuildContext context) {
    Navigator.of(context).pop(state.saveVoteResult());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Vote for task'),
        ),
        body: Column(
          children: [
            Text(state.votedTask.readableTitle),
            const SizedBox(height: Constants.fieldVerticalSpace),
            if (state.votedTask.description != null) ...[
              Text(state.votedTask.description!),
              const SizedBox(height: Constants.fieldVerticalSpace)
            ],
            Expanded(
              flex: 1,
              child: state.isInTeam
                  ? Observer(
                      builder: (_) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.persons.length,
                        itemBuilder: (context, index) => PersonCard(
                          state.persons[index].key,
                          vote: state.persons[index].value,
                          isSelected: state.persons[index].key ==
                              state.selectedVotingPerson,
                          onSelect: () => state
                              .selectPersonToVote(state.persons[index].key),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              flex: 2,
              child: Observer(
                builder: (_) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width / 4,
                      childAspectRatio: 1,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: state.possibleVotes.length,
                  itemBuilder: (context, index) => VoteSelectionCard(
                    state.possibleVotes[index],
                    isSelected: state.votes[state.selectedVotingPerson] ==
                        state.possibleVotes[index],
                    onSelect: state.setVote,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Observer(
            builder: (_) => state.canSaveVote
                ? FloatingActionButton(
                    child: const Icon(Icons.save),
                    onPressed: () => _saveAndClose(context),
                  )
                : state.haveAllVotes
                    ? FloatingActionButton(
                        child: const Icon(Icons.clear),
                        tooltip: 'Clear',
                        onPressed: state.clearVotes,
                      )
                    : const SizedBox()),
      );
}
