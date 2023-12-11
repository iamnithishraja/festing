import 'package:fests/screens/fests/userScreens/fest.dart';
import 'package:fests/screens/orders/userScreens/order.dart';
import 'package:fests/screens/profile/ProfileScreen.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          Fests(),
          OrdersScreen(),
          Container(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        child: TabBar(
          labelColor: Theme.of(context).colorScheme.secondary,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: [
            Tab(
              text: "Fests",
              icon: Icon(Icons.festival),
            ),
            Tab(
              text: "Activity",
              icon: Icon(Icons.directions_run),
            ),
            Tab(
              text: "Media",
              icon: Icon(Icons.play_circle_filled),
            ),
            Tab(
              text: "Profile",
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
