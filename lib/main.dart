import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Initialize the FlutterLocalNotificationsPlugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

Future<void> _createNotficationChannel(
    String id, String name, String sound) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var androidNotificationChannel = AndroidNotificationChannel(
    id,
    name,
    sound: RawResourceAndroidNotificationSound(sound),
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}


late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AwesomeNotifications().initialize(
  //   null,
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic notifications',
  //       defaultColor: Colors.teal,
  //       ledColor: Colors.teal,
  //       playSound: true,
  //       enableVibration: true,
  //     ),
  //   ],
  // );
  AssetPicker.registerObserve(
    (value) {
      print(value);
    },
  );
  
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');


  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: initializationSettingsAndroid),
  );

  // Create a notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'message',
    'message',
    sound: RawResourceAndroidNotificationSound('doraemon'),
  );

  // Create a notification channel with the channel ID
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Set the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
