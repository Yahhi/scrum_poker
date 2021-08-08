import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlideActionsWrapper extends StatelessWidget {
  const SlideActionsWrapper({Key? key, required this.onEdit, required this.onDelete, this.onTap, required this.child}) : super(key: key);

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  final Widget child;

  @override
  Widget build(BuildContext context) => Slidable(
        key: UniqueKey(),
        dismissal: SlidableDismissal(
          dismissThresholds: const <SlideActionType, double>{SlideActionType.primary: .5, SlideActionType.secondary: .5},
          closeOnCanceled: true,
          onWillDismiss: (actionType) {
            if (actionType == SlideActionType.primary) {
              onEdit();
              return false;
            } else {
              onDelete();
              return false;
            }
          },
          child: const SlidableDrawerDismissal(),
        ),
        actions: [
          IconSlideAction(
            color: Colors.green,
            icon: Icons.edit,
            onTap: onEdit,
          )
        ],
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete_outline,
            onTap: onDelete,
          )
        ],
        movementDuration: const Duration(milliseconds: 100),
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        child: onTap == null
            ? child
            : InkWell(
                onTap: onTap,
                child: child,
              ),
      );
}
