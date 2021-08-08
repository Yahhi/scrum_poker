import 'package:flutter/material.dart';
import 'package:scrum_poker/model/person.dart';

class PersonAvatar extends StatelessWidget {
  const PersonAvatar(this.person, {Key? key, this.onChangeAction, this.avatarRadius}) : super(key: key);

  final Person? person;
  final double? avatarRadius;
  final VoidCallback? onChangeAction;

  ImageProvider<Object> get _localImage =>
      person!.imageType == ImageType.local ? AssetImage(person!.imageAddress!) : const AssetImage('assets/images/cat_portrait.jpeg');

  Widget _buildTakePicturePlaceholder(BuildContext context) => InkWell(
        onTap: onChangeAction,
        child: CircleAvatar(
          child: const Icon(Icons.photo_camera),
          radius: avatarRadius,
        ),
      );

  Widget _buildPersonAvatar(BuildContext context, Person person) => onChangeAction == null
      ? CircleAvatar(
          radius: avatarRadius,
          backgroundImage: person.imageType == ImageType.network ? NetworkImage(person.imageAddress!) : _localImage,
        )
      : InkWell(
          onTap: onChangeAction,
          child: CircleAvatar(
            radius: avatarRadius,
            child: const Icon(Icons.photo_camera),
            backgroundImage: person.imageType == ImageType.network ? NetworkImage(person.imageAddress!) : _localImage,
          ),
        );

  @override
  Widget build(BuildContext context) => person == null ? _buildTakePicturePlaceholder(context) : _buildPersonAvatar(context, person!);
}
