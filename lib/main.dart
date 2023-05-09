import 'package:chat_app/auth/login.dart';

import 'package:chat_app/scrrens/myhomepage.dart';
import 'package:chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
      // home: FirebaseAuth.instance.currentUser == null
      // ? LoginPage()
      // : MyHomePage(),
    );
  }
}
