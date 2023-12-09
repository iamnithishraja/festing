import 'package:fests/models/event.dart';
import 'package:fests/models/order.dart';
import 'package:fests/models/user.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserItem extends ConsumerStatefulWidget {
  UserItem({required this.order, required this.user, super.key});
  Order order;
  User user;
  @override
  ConsumerState<UserItem> createState() => _UserItemState();
}

class _UserItemState extends ConsumerState<UserItem> {
  @override
  Widget build(BuildContext context) {
    late Widget trailingWidget;
    var userStatus = widget.order.team
        .firstWhere(
          (teamMate) => teamMate.keys.first.id == widget.user.id,
          orElse: () => {widget.user: "notFound"},
        )
        .values
        .first;

    if (userStatus == "accepted") {
      trailingWidget = SubHeading(
        str: "accepted",
        color: Colors.green,
      );
    } else if (userStatus == "rejected") {
      trailingWidget = SubHeading(
        str: "rejected",
        color: Colors.red,
      );
    } else if (userStatus == "waiting") {
      trailingWidget = SubHeading(
        str: "waiting",
        color: Colors.yellow,
      );
    } else {
      trailingWidget = TextButton(
        child: SubHeading(
          align: TextAlign.center,
          str: "Send\nRequest",
          fontSize: 14,
          color: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: () {
          ref
              .watch(allUsersProvider.notifier)
              .sendRequest(widget.order.id, widget.user.id);
          setState(() {
            widget.order.team.add({widget.user: "waiting"});
          });
        },
      );
    }

    final dp = widget.user.avatar == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(widget.user.avatar!);

    return Card(
      shadowColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: dp as ImageProvider,
          radius: 30,
        ),
        minVerticalPadding: 10,
        tileColor: Theme.of(context).colorScheme.primary,
        title: Heading(
          str: widget.user.name,
          fontSize: 18,
        ),
        subtitle: SubHeading(
          str: widget.user.rollno,
          fontSize: 14,
        ),
        trailing: trailingWidget,
      ),
    );
  }
}
