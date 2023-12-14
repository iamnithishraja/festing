import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:fests/models/order.dart';
import 'package:fests/models/user.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class orderNotifier extends StateNotifier<List<Order>> {
  orderNotifier() : super([]);
  Future<Order> createOrder(
      {required String eventId, required String userId}) async {
    final response = await http.postBody("$baseUrl/orders/order",
        "application/json", {"eventId": eventId, "userId": userId});

    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: "your registration completed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    final order = response["order"];
    List<List<DateTime>> schedule = [];
    for (List pair in order["event"]["schedule"]) {
      schedule.add([
        DateTime.parse(pair[0]).toLocal(),
        DateTime.parse(pair[1]).toLocal()
      ]);
    }
    final event = Event(
        id: order["event"]["_id"],
        name: order["event"]["name"],
        description: order["event"]["description"],
        image: order["event"]["poster"]["url"],
        category: order["event"]["category"],
        details: [...order["event"]["details"]],
        price: order["event"]["price"],
        teamSize: order["event"]["teamSize"],
        venue: order["event"]["venue"],
        scedule: schedule,
        mapsLink: order["event"]["location"]);

    List<Map<User, String>> team = [];
    for (final member in order["team"]) {
      final user = User(
          id: member["user"]["_id"],
          name: member["user"]["name"],
          email: member["user"]["email"],
          rollno: member["user"]["rollno"],
          role: member["user"]["role"]);
      final status = member["status"];
      team.add({user: status});
    }
    return Order(id: order["_id"], event: event, team: team);
  }

  Future<void> getAllOrders(String userId) async {
    final response = await http.get(
      "$baseUrl/orders/all/$userId",
      "application/json",
    );
    if (response["success"]) {
      List<Order> orders = [];
      for (var order in response["orders"]) {
        List<List<DateTime>> schedule = [];
        for (List pair in order["event"]["schedule"]) {
          schedule.add([
            DateTime.parse(pair[0]).toLocal(),
            DateTime.parse(pair[1]).toLocal()
          ]);
        }
        final event = Event(
            id: order["event"]["_id"],
            name: order["event"]["name"],
            description: order["event"]["description"],
            image: order["event"]["poster"]["url"],
            category: order["event"]["category"],
            details: [...order["event"]["details"]],
            price: order["event"]["price"],
            teamSize: order["event"]["teamSize"],
            venue: order["event"]["venue"],
            scedule: schedule,
            mapsLink: order["event"]["location"]);
        List<Map<User, String>> team = [];
        for (final member in order["team"]) {
          final user = User(
              id: member["user"]["_id"],
              name: member["user"]["name"],
              email: member["user"]["email"],
              rollno: member["user"]["rollno"],
              avatar: (member["user"]["avatar"] != null)
                  ? member["user"]["avatar"]["url"]
                  : null,
              role: member["user"]["role"]);
          final status = member["status"];
          team.add({user: status});
        }
        orders.add(Order(id: order["_id"], event: event, team: team));
      }
      state = orders;
    }
  }

  String getUserStatus(Order order, User user) {
    var userStatus = order.team
        .firstWhere(
          (teamMate) => teamMate.keys.first.id == user.id,
          orElse: () => {user: "notFound"},
        )
        .values
        .first;
    return userStatus;
  }
}

final OrdersProvider = StateNotifierProvider<orderNotifier, List<Order>>((ref) {
  return orderNotifier();
});
