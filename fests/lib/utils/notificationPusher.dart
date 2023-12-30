import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationManager {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
  }
}
