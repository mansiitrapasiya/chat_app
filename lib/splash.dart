// import 'dart:async';
// import 'dart:developer';


// import 'package:chat_app/classes/apiclass.dart';
// import 'package:chat_app/homepage.dart';
// import 'package:chat_app/login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   State<Splashscreen> createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   bool isAlimate = false;
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 2), () {
//       log('\nUser:${FirebaseAuth.instance.currentUser}');

//       if (Apis.auth.currentUser != null) {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) {
//           return MyHomePage();
//         }));
//       } else {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) {
//           return LoginScrren();
//         }));
//       }

//       setState(() {
//         isAlimate = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(50),
//             child: Image.asset('assets/p1.png'),
//           )
//         ],
//       ),
//     );
//   }
// }
