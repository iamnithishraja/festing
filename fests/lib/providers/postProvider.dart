import 'package:fests/globals/constants.dart';
import 'package:fests/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class postNotifier extends StateNotifier<List<Post>> {
  postNotifier() : super([]);
  Future<List<String>> getAllCategories() async {
    final response =
        await http.get("$baseUrl/post/category", "application/json");
    print("called");
    return [...response["categories"]];
  }
}

final postProvider =
    StateNotifierProvider<postNotifier, List<Post>>((ref) => postNotifier());
