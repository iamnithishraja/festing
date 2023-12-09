import 'package:fests/models/event.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.rollno,
    this.avatar,
    required this.role,
  });
  String email, name,id,rollno,role;
  String? avatar;
  List<User>? requests;
  List<String>? orders;
}
