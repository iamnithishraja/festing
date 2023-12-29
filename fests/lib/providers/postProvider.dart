import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:fests/globals/constants.dart';
import 'package:fests/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class postNotifier extends StateNotifier<List<Map>> {
  postNotifier() : super([]);
  Future<List<String>> getAllCategories() async {
    final response =
        await http.get("$baseUrl/post/category", "application/json");
    return [...response["categories"]];
  }

  Future<void> createNewPost(
      File postImage, String caption, String category) async {
    FormData requestBody = FormData.fromMap({
      "category": category,
      "caption": caption.trim(),
      "image": await MultipartFile.fromFile(postImage.path,
          filename: postImage.path.split("/").last)
    });
    final response = await http.postForm(
        "$baseUrl/post/post/upload", 'multipart/form-data', requestBody);

    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "new post added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> deletePost(String id) async {
    final response =
        await http.delete("$baseUrl/post/post/$id", 'application/json', {});
    if (response!["success"]) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Post deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> likeunlikePost(String id) async {
    final response =
        await http.get("$baseUrl/post/post/$id", "application/json");
  }

  Future<void> commentOnPost(String postID, String comment) async {
    final response = await http.putForm("$baseUrl/post/post/comment/$postID",
        "application/json", FormData.fromMap({"comment": comment}));
    if (response!["success"]) {
      getPostComments(postID);
    }
  }

  Future<Map> getPostComments(String postId) async {
    final response =
        await http.get("$baseUrl/post/comments/$postId", "application/json");

    return response;
  }
}

final postsProvider =
    StateNotifierProvider<postNotifier, List<Map>>((ref) => postNotifier());
