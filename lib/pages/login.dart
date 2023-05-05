import 'dart:developer';

import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/myhome.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailContoller = TextEditingController();
  TextEditingController paasswordContoller = TextEditingController();
  void checkVal() {
    String email = emailContoller.text.trim();
    String password = paasswordContoller.text.trim();
    if (email == "" || password == "") {
      print('fill it');
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      print('Login Successfully');
      log("Login suchshcb scvj");

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(
            firebaseUser: credential!.user!, userModel: userModel);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Chat App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  TextField(
                    controller: emailContoller,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: paasswordContoller,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    child: Text('Login'),
                    onPressed: () {
                      checkVal();
                    },
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t have an account? ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            CupertinoButton(
                child: Text(
                  'Sign up? ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignupPage();
                  }));
                })
          ],
        ),
      ),
    );
  }
}
