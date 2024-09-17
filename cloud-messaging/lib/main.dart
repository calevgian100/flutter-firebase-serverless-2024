import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_do_app/auth/logic/firebase_auth_service.dart';
import 'package:todo_do_app/auth/screen/create_account.dart';
import 'package:todo_do_app/auth/screen/login_screen.dart';
import 'package:todo_do_app/messaging/logic/messaging_service.dart';
import 'package:todo_do_app/to_do_list/screens/todo_do_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MessagingService.init();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      useMaterial3: true,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setupInteractedMessage();
    MessagingService.initForegroundNotifications(onSelectNotification);
    super.initState();
  }

  void onSelectNotification(NotificationResponse response) {
    if (response.payload == 'Pepe') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ToDoScreen(),
        ),
      );
    }
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.notification?.title == 'Juan') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateAccount(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuthService.currentUser == null
        ? LoginScreen()
        : const ToDoScreen();
  }
}
