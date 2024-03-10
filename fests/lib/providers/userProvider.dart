import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class userNotifier extends StateNotifier<User?> {
  userNotifier() : super(null);

  Future<void> tryAutoLogin() async {
    final response =
        await http.autoLoginRequest("$baseUrl/user/me", 'application/json');
    print(response);
    if (response["success"]) {
      Map<String, String> mp = {
        if (response["user"]["socialLinks"] != null &&
            response["user"]["socialLinks"]["github"] != null)
          "github": response["user"]["socialLinks"]["github"],
        if (response["user"]["socialLinks"] != null &&
            response["user"]["socialLinks"]["linkdlin"] != null)
          "linkdlin": response["user"]["socialLinks"]["linkdlin"],
        if (response["user"]["socialLinks"] != null &&
            response["user"]["socialLinks"]["codingPlatform"] != null)
          "codingPlatform": response["user"]["socialLinks"]["codingPlatform"]
      };
      state = User(
        id: response["user"]["_id"],
        name: response["user"]["name"],
        email: response["user"]["email"],
        rollno: response["user"]["rollno"],
        role: response["user"]["role"],
        avatar: (response["user"]["avatar"] != null)
            ? response["user"]["avatar"]["url"]
            : null,
        bio: response["user"]["bio"],
        socialLinks: response["user"]["socialLinks"] != null ? mp : {},
      );
    }
  }

  Future<void> login(String email, String password) async {
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };
    final response = await http.postBody(
      "$baseUrl/user/login",
      'application/json',
      requestBody,
    );
    if (response['success']) {
      tryAutoLogin();
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> register(
    String name,
    String email,
    String rollno,
    String password,
  ) async {
    try {
      final Map<String, String> requestBody = {
        'name': name,
        'email': email,
        'rollno': rollno,
        'password': password,
      };

      final response = await http.postBody(
        '$baseUrl/user/register',
        'application/json',
        requestBody,
      );

      if (response['success']) {
        tryAutoLogin();
      } else {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: response['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 5,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    final response = await http.get("$baseUrl/user/logout", "application/json");
    if (response['success']) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "logged out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 16.0);
      state = null;
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> updateProfile(
      {String? email,
      rollno,
      name,
      bio,
      github,
      linkdlin,
      cp,
      File? dp}) async {
    final mp = jsonEncode({
      if (github != null) "github": github,
      if (linkdlin != null) "linkdlin": linkdlin,
      if (cp != null) "codingPlatform": cp
    });
    FormData requestBody = FormData.fromMap({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (rollno != null) 'rollno': rollno,
      if (bio != null) 'bio': bio,
      if (mp != {}) 'socialLinks': mp,
      if (dp != null)
        "avatar": await MultipartFile.fromFile(dp!.path,
            filename: dp.path.split("/").last)
    });
    final response = await http.putForm(
        "$baseUrl/user/me", "multipart/form-data", requestBody);
    if (response!['success']) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "updated user successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 16.0);
      tryAutoLogin();
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 5,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

final userProvider =
    StateNotifierProvider<userNotifier, User?>((ref) => userNotifier());

class usersNotifier extends StateNotifier<List<User>> {
  usersNotifier(this.ref) : super([]);
  Ref ref;
  Future<void> getAllUsers({String? keyword, int page = 1}) async {
    if (keyword == null) {
      keyword = ref.watch(userProvider)!.rollno.substring(0, 6);
    }
    final response = await http.makeSerchQuery(
        "$baseUrl/user/all?keyword=$keyword&page=$page", "application/json");
    List<User> users = [];
    if (response["success"]) {
      for (var user in response["users"]) {
        if (user["_id"] != ref.watch(userProvider)!.id) {
          users.add(User(
            id: user["_id"],
            name: user["name"],
            email: user["email"],
            rollno: user["rollno"],
            role: user["role"],
            avatar: (user["avatar"] != null) ? user["avatar"]["url"] : null,
          ));
        }
      }
      state = users;
    }
  }

  Future<void> sendRequest(String orderId, String userId) async {
    final response = await http.postBody("$baseUrl/user/request",
        "application/json", {"orderId": orderId, "userId": userId});
    if (response["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "request sent successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (response["resent"]) {
        ref.read(OrdersProvider.notifier).getAllOrders(userId);
      }
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: response["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> acceptRequest(String orderId, String userId) async {
    final response = await http.putForm(
      "$baseUrl/user/request",
      "multipart/form-data'",
      FormData.fromMap({"orderId": orderId, "userId": userId}),
    );
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "accepted request",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      ref.read(OrdersProvider.notifier).getAllOrders(userId);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: response["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> rejectRequest(String orderId, String userId) async {
    final response = await http.delete(
      "$baseUrl/user/request",
      "application/json",
      {"orderId": orderId, "userId": userId},
    );
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "requesst rejected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await ref.read(OrdersProvider.notifier).getAllOrders(userId);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: response["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIosWeb: 5,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<User?> getUserDetails(String id) async {
    final response = await http.get(
        "$baseUrl/user/getotheruserdetails/$id", "application/json");
    Map<String, String> mp = {
      if (response["user"]["socialLinks"] != null &&
          response["user"]["socialLinks"]["github"] != null)
        "github": response["user"]["socialLinks"]["github"],
      if (response["user"]["socialLinks"] != null &&
          response["user"]["socialLinks"]["linkdlin"] != null)
        "linkdlin": response["user"]["socialLinks"]["linkdlin"],
      if (response["user"]["socialLinks"] != null &&
          response["user"]["socialLinks"]["codingPlatform"] != null)
        "codingPlatform": response["user"]["socialLinks"]["codingPlatform"]
    };
    if (response["success"]) {
      return User(
        id: response["user"]["_id"],
        name: response["user"]["name"],
        email: response["user"]["email"],
        rollno: response["user"]["rollno"],
        role: response["user"]["role"],
        avatar: (response["user"]["avatar"] != null)
            ? response["user"]["avatar"]["url"]
            : null,
        bio: response["user"]["bio"],
        socialLinks: response["user"]["socialLinks"] != null ? mp : {},
      );
    }
  }
}

final allUsersProvider =
    StateNotifierProvider<usersNotifier, List<User>>((ref) {
  return usersNotifier(ref);
});
