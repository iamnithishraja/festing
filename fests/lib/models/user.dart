import 'package:fests/models/event.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.rollno,
    this.avatar,
    this.bio,
    this.socialLinks,
    required this.role,
  });
  String email, name, id, rollno, role;
  String? avatar;
  String? bio;
  List<User>? requests;
  List<String>? orders;
  Map<String, String>? socialLinks;
}
