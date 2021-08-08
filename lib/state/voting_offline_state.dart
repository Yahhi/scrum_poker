import 'package:mobx/mobx.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/model/project.dart';
import 'package:scrum_poker/model/task.dart';

part 'voting_offline_state.g.dart';

class VotingOfflineState = _VotingOfflineState with _$VotingOfflineState;

abstract class _VotingOfflineState with Store {
  _VotingOfflineState(this.votedTask, this._project) {
    for (var person in _project.members) {
      votes[person] = 0;
    }
    selectedVotingPerson = votes.keys.first;
  }

  final Task votedTask;
  final Project _project;

  bool get isInTeam => _project.usageType != UsageType.personal;

  @observable
  ObservableMap<Person, int> votes = ObservableMap();

  @computed
  ObservableList<MapEntry<Person, int>> get persons =>
      ObservableList.of(votes.entries);

  List<int> possibleVotes = [1, 2, 3, 5, 8, 13, 17, 23];

  @observable
  Person? selectedVotingPerson;

  @computed
  bool get haveConsensus =>
      votes.values.first != 0 &&
      votes.values.fold(
          true,
          (previousValue, element) =>
              previousValue && element == votes.values.first);

  @computed
  bool get haveAllVotes => !votes.values.any((element) => element == 0);

  @computed
  bool get canSaveVote =>
      (selectedVotingPerson != null && haveAllVotes) || haveConsensus;

  @action
  void clearVotes() {
    for (var person in votes.keys) {
      votes[person] = 0;
    }
    selectedVotingPerson = null;
  }

  @action
  void selectPersonToVote(Person person) {
    if (selectedVotingPerson == person) {
      selectedVotingPerson = null;
    } else {
      selectedVotingPerson = person;
    }
  }

  @action
  int saveVoteResult() {
    return selectedVotingPerson == null
        ? votes.values.first
        : votes[selectedVotingPerson]!;
  }

  @action
  void setVote(int value) {
    if (selectedVotingPerson == null) {
      return;
    }
    votes[selectedVotingPerson!] = value;
    for (var mapEntry in votes.entries) {
      if (mapEntry.value == 0) {
        selectedVotingPerson = mapEntry.key;
        break;
      }
    }
  }
}
