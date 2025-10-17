import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    // request permissions on iOS/macOS
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && token != null) {
        // Save token under users/{uid}/tokens/{token}
        await FirestoreService().saveNotificationToken(user.uid, token);
      }
    } catch (_) {
      // ignore errors here
    }
    return token;
  }
}
