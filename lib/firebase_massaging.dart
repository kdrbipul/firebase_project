import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingServices {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    // Hide
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });


    // Foreground
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      print(message.notification?.title);
      print(message.notification?.body);
    });

    FirebaseMessaging.onBackgroundMessage((doSomeThing));
  }
}

Future<void> doSomeThing(RemoteMessage message) async {

}