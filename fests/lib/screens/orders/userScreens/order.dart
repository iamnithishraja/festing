import 'package:fests/providers/eventProvider.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/screens/events/adminScreens/CreateEvent.dart';
import 'package:fests/screens/events/adminScreens/UpdateEvent.dart';
import 'package:fests/widgets/listItems/event_item.dart';
import 'package:fests/widgets/listItems/order_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/models/user.dart';
import 'package:fests/models/fest.dart';
import 'package:fests/models/event.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/listItems/fest_item.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  OrdersScreen({super.key});
  @override
  ConsumerState<OrdersScreen> createState() => _EventsState();
}

class _EventsState extends ConsumerState<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider) as User;

    return Scaffold(
      appBar: AppBar(
        title: Heading(str: "My Events"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: ref.read(OrdersProvider.notifier).getAllOrders(user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            final orders = ref.watch(OrdersProvider) as List;
            return RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                onRefresh: () =>
                    ref.read(OrdersProvider.notifier).getAllOrders(user.id),
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return OrderItem(orders[index]);
                      },
                      itemCount: orders.length,
                    )));
          }),
    );
  }
}
