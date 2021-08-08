import 'package:flutter/material.dart';

class VoteSelectionCard extends StatelessWidget {
  const VoteSelectionCard(this.value,
      {Key? key, this.isSelected = false, this.onSelect})
      : super(key: key);

  final int value;
  final bool isSelected;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onSelect == null ? null : () => onSelect!(value),
        child: Card(
          elevation: isSelected ? 8 : 2,
          child: Text(value.toString()),
        ),
      );
}
