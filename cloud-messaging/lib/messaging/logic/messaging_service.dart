import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background notification received!!');
  print('${message.notification!.title}');
  print('${message.notification!.body}');
}

class MessagingService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _messaging.requestPermission();

    _initBackgroundNotifications();
    final token = await getToken();
    print('token');
    print(token);
  }

  static void _initBackgroundNotifications() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void initForegroundNotifications(
      void Function(NotificationResponse foregroundNotification)
          handleOnTap) async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('launch_background'),
      ),
      onDidReceiveNotificationResponse: handleOnTap,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
                // other properties...
              ),
            ),
            payload: notification.title,
          );
        }
      },
    );
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
