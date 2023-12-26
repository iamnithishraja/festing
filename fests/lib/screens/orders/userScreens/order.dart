import 'package:fests/models/order.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/widgets/listItems/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/models/user.dart';
import 'package:fests/providers/userProvider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  OrdersScreen({super.key});
  @override
  ConsumerState<OrdersScreen> createState() => _EventsState();
}

class _EventsState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController1;
  @override
  void initState() {
    _tabController1 = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider) as User;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).primaryColor,
        title: TabBar(
          physics: NeverScrollableScrollPhysics(),
          indicatorColor: Colors.white,
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.background),
          controller: _tabController1,
          tabs: [
            Tab(
              text: "MyEvents",
              icon: Icon(Icons.calendar_month),
            ),
            Tab(
              text: "Requests",
              icon: Icon(Icons.pending),
            )
          ],
        ),
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
            final orders = ref.watch(OrdersProvider) as List<Order>;
            final myevents = [];
            final requests = [];
            for (var order in orders) {
              if (ref
                      .read(OrdersProvider.notifier)
                      .getUserStatus(order, user) ==
                  "waiting") {
                requests.add(order);
              } else {
                myevents.add(order);
              }
            }
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController1,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return OrderItem(orders[index], false);
                      },
                      itemCount: myevents.length,
                    )),
                RefreshIndicator(
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
                          return OrderItem(orders[index], true);
                        },
                        itemCount: requests.length,
                      )),
                ),
              ],
            );
          }),
    );
  }
}
