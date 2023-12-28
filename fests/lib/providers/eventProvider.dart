import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class eventNotifier extends StateNotifier<List<Event>> {
  eventNotifier() : super([]);

  Future<void> createEvent({
    required String festId,
    required String eventName,
    required String description,
    required List<String> details,
    required int price,
    required int teamSize,
    required File poster,
    required String category,
    required String venue,
    required String location,
    required List<List<DateTime>> schedule,
  }) async {
    List<List<String>> scheduleStrings = [];

    FormData requestBody = FormData.fromMap({
      "festId": festId,
      "name": eventName.trim(),
      "description": description.trim(),
      "details": details,
      "price": price,
      "teamSize": teamSize,
      "location": location.trim(),
      "venue": venue.trim(),
      "category": category.trim(),
      "schedule": schedule,
      "poster": await MultipartFile.fromFile(poster.path,
          filename: poster.path.split("/").last),
    });

    final response = await http.postForm(
      "$baseUrl/fests/event",
      'multipart/form-data',
      requestBody,
    );
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "new event added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "failed to add new event",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> updateEvent({
    required String eventId,
    required String? eventName,
    required String? description,
    required List<String>? details,
    required int? price,
    required int? teamSize,
    required File? poster,
    required String? category,
    required String? venue,
    required String? location,
    required List<List<DateTime>> schedule,
  }) async {
    FormData requestBody = FormData.fromMap({
      "eventId": eventId,
      if (eventName != null) "name": eventName.trim(),
      if (description != null) "description": description.trim(),
      if (details != null) "details": details,
      if (price != null) "price": price,
      if (teamSize != null) "teamSize": teamSize,
      if (location != null) "location": location.trim(),
      if (venue != null) "venue": venue.trim(),
      if (category != null) "category": category.trim(),
      "schedule": schedule,
      if (poster != null)
        "poster": await MultipartFile.fromFile(poster.path,
            filename: poster.path.split("/").last),
    });
    final response = await http.putForm(
        "$baseUrl/fests/event", "multipart/form-data", requestBody);
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "event edited succesfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "failed to edit event",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> deleteEvent(String id) async {
    final response = await http
        .delete("$baseUrl/fests/event", "application/json", {"id": id});

    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "event delete completed",
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

  Future<void> getEvents(String festId) async {
    final response =
        await http.get("$baseUrl/fests/events/$festId", "application/json");
    List<Event> events = [];
    if (response["success"]) {
      for (final event in response["events"]) {
        List<List<DateTime>> schedule = [];
        for (List pair in event["schedule"]) {
          schedule.add([
            DateTime.parse(pair[0]).toLocal(),
            DateTime.parse(pair[1]).toLocal()
          ]);
        }
        events.add(Event(
          id: event["_id"],
          name: event["name"],
          description: event["description"],
          image: event["poster"]["url"],
          category: event["category"],
          details: [...event["details"]],
          price: event["price"],
          teamSize: event["teamSize"],
          venue: event["venue"],
          mapsLink: event["location"],
          scedule: schedule,
        ));
      }
      state = events;
    }
  }
}

final eventProvider =
    StateNotifierProvider<eventNotifier, List<Event>>((ref) => eventNotifier());
