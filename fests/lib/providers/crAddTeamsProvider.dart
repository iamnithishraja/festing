import 'dart:convert';

import 'package:fests/globals/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class crAddTeamsNotifier extends StateNotifier {
  crAddTeamsNotifier() : super([]);

  Future<void> addTeam(List<String> rollnos, String id) async {
    final response = await http.postBody("$baseUrl/orders/event/cr/$id",
        "application/json", {"rollnos": rollnos});
    if (response["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "successfully added new team",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "failed to add new team",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

final crAddTeamsProvider = StateNotifierProvider((ref) => crAddTeamsNotifier());
