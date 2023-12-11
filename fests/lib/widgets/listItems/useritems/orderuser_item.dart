import 'package:fests/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderUserItem extends ConsumerStatefulWidget {
  OrderUserItem({required this.user, required this.trailing, super.key});
  User user;
  Widget trailing;
  @override
  ConsumerState<OrderUserItem> createState() => _UserItemState();
}

class _UserItemState extends ConsumerState<OrderUserItem> {
  @override
  Widget build(BuildContext context) {
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
        tileColor: Theme.of(context).colorScheme.background,
        title: Heading(
          str: widget.user.name,
          fontSize: 18,
        ),
        subtitle: SubHeading(
          str: widget.user.rollno,
          fontSize: 14,
        ),
        trailing: widget.trailing,
      ),
    );
  }
}
