import 'package:fests/models/event.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/widgets/listItems/order_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventTeamsScreen extends ConsumerStatefulWidget {
  EventTeamsScreen(this.event, {super.key});
  Event event;
  @override
  ConsumerState<EventTeamsScreen> createState() => _EventTeamsScreenState();
}

class _EventTeamsScreenState extends ConsumerState<EventTeamsScreen> {
  @override
  Widget build(BuildContext context) {
    void confirmDeleteOrder(String orderId) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            title: Heading(str: "Are You Sure?"),
            shadowColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: SubHeading(
                str:
                    "this team will be removed will no longer be able to participate"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: SubHeading(
                    str: "Cancel",
                    color: Colors.green,
                  )),
              TextButton(
                  onPressed: () {
                    ref.read(eventOrdersProvider.notifier).deleteOrder(orderId);
                    Navigator.of(context).pop();
                  },
                  child: SubHeading(
                    str: "Confirm",
                    color: Colors.red,
                  ))
            ]),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Heading(str: widget.event.name)),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        future: ref
            .read(eventOrdersProvider.notifier)
            .getAllOrdersByEvent(widget.event.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }
          final orders = ref.watch(eventOrdersProvider);
          return ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () => confirmDeleteOrder(orders[index].id),
                child: OrderItem(
                  orders[index],
                  false,
                  [],
                  isViewedAsList: true,
                ),
              );
            },
            itemCount: orders.length,
          );
        },
      ),
    );
  }
}
