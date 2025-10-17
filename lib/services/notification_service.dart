import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    // request permissions on iOS/macOS
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    return token;
  }
}
