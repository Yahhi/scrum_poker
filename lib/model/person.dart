import 'package:mobx/mobx.dart';

part 'person.g.dart';

class Person = _Person with _$Person;

abstract class _Person with Store {
  _Person({this.id, this.name, this.imageAddress});

  final String? id;

  @observable
  String? name;

  @observable
  String? imageAddress;

  @computed
  ImageType get imageType => imageAddress == null
      ? ImageType.placeholder
      : imageAddress!.startsWith('http')
          ? ImageType.network
          : ImageType.local;

  @computed
  String get readableName => name ?? 'unnamed';

  Person copyWithUpdatedId(String id) =>
      Person(id: id, name: name, imageAddress: imageAddress);
}

enum ImageType { local, network, placeholder }
