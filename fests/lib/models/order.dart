import 'package:fests/models/event.dart';
import 'package:fests/models/user.dart';

class Order {
  Order({required this.id, required this.event, required this.team});
  String id;
  Event event;
  List<Map<User, String>> team;
}
