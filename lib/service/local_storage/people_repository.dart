import 'dart:math';

import 'package:scrum_poker/data/mock_data.dart';
import 'package:scrum_poker/model/person.dart';
import 'package:scrum_poker/service/repository_interface.dart';
import 'package:scrum_poker/service/repository_result.dart';

class LocalPeopleRepository extends PeopleRepository {
  @override
  Future<RepositoryResult<Person>> addPerson(Person person) async {
    final updatedPerson = person.copyWithUpdatedId(Random().nextInt(10000).toString());
    mockPeople.add(updatedPerson);
    return RepositoryResult(data: updatedPerson);
  }

  @override
  Future<RepositoryResult<bool>> deletePerson(Person person) async {
    return RepositoryResult(data: true);
  }

  @override
  Future<RepositoryResult<List<Person>>> fetchKnownPeople() async {
    return RepositoryResult(data: mockPeople);
  }

  @override
  Future<RepositoryResult<bool>> updatePerson(Person person) async {
    return RepositoryResult(data: true);
  }
}
