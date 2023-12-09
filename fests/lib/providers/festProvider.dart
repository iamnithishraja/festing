import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:flutter/material.dart';
import '../models/fest.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class festNotifier extends StateNotifier {
  festNotifier() : super([]);

  Future<void> createFest({
    required String festName,
    required String collegeName,
    required String description,
    required String collegeWebsite,
    String? festWebsite,
    required String location,
    required String startDate,
    required String endDate,
    required File poster,
    required String broture,
  }) async {
    FormData requestBody = FormData.fromMap({
      "name": festName.trim(),
      "collegeName": collegeName.trim(),
      "description": description.trim(),
      "collegeWebsite": collegeWebsite.trim(),
      "festWebsite": festWebsite != null ? festWebsite.trim() : null,
      "location": location.trim(),
      "startDate": startDate.trim(),
      "endDate": endDate.trim(),
      "poster": await MultipartFile.fromFile(poster.path,
          filename: poster.path.split("/").last),
      "broture": broture.trim(),
    });

    final response = await http.postForm(
      "$baseUrl/fests/fest",
      'multipart/form-data',
      requestBody,
    );
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "new fest uploaded complete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "failed to upload new fest",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> getFests() async {
    final response =
        await http.get("$baseUrl/fests/eligible", "application/json");
    if (response["success"]) {
      final List<Fest> fests = [];
      for (final fest in response["fests"]) {
        fests.add(Fest(
            collegeName: fest["collegeName"],
            id: fest["_id"],
            festName: fest["name"],
            collegeWebsite: fest["collegeWebsite"],
            description: fest["description"],
            location: fest["location"],
            startDate: fest["startDate"],
            endDate: fest["endDate"],
            poster: fest["poster"]["url"],
            broture: fest["broture"],
            festWebsite: fest["festWebsite"]));
      }
      state = fests;
    }
  }

  Future<void> updateFest({
    required String id,
    required String? festName,
    required String? collegeName,
    required String? description,
    required String? collegeWebsite,
    String? festWebsite,
    required String? location,
    required String? startDate,
    required String? endDate,
    required File? poster,
    required String? broture,
  }) async {
    FormData requestBody = FormData.fromMap({
      "id": id,
      if (festName != null) "name": festName.trim(),
      if (collegeName != null) "collegeName": collegeName.trim(),
      if (description != null) "description": description.trim(),
      if (collegeWebsite != null) "collegeWebsite": collegeWebsite.trim(),
      if (festWebsite != null) "festWebsite": festWebsite.trim(),
      if (location != null) "location": location.trim(),
      if (startDate != null) "startDate": startDate.trim(),
      if (endDate != null) "endDate": endDate.trim(),
      if (poster != null)
        "poster": await MultipartFile.fromFile(poster.path,
            filename: poster.path.split("/").last),
      if (broture != null) "broture": broture.trim(),
    });

    final response = await http.putForm(
        "$baseUrl/fests/fest", "multipart/form-data", requestBody);
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "fest update completed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "failed to update",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> deleteFest(String id) async {
    final response = await http
        .delete("$baseUrl/fests/fest", "application/json", {"id": id});

    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "fest delete completed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "failed to delete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}

final festProvider = StateNotifierProvider((ref) => festNotifier());
