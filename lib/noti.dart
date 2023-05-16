import 'package:firebase_messaging/firebase_messaging.dart';

class CustomNotification{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  
  Future<void> requesnotificationPermission()async{
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true ,
      carPlay: true,
      criticalAlert: true,
      provisional: true
    );
  
  }
}