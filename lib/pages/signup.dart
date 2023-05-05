import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/completprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailContoller = TextEditingController();
  TextEditingController paasswordContoller = TextEditingController();
  TextEditingController cpasswordemailC = TextEditingController();
  void checkVal() {
    String email = emailContoller.text.trim();
    String password = paasswordContoller.text.trim();
    String confrimPass = cpasswordemailC.text.trim();
    if (email == "" || password == "" || confrimPass == "") {
      print('fill it');
    } else if (password != confrimPass) {
      print('Dont match');
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;

      UserModel newUser =
          UserModel(uid: uid, email: email, fullName: "", profile: "");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        print('New user created');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfilePage(
              firebaseUser: credential!.user!, userModel: newUser);
        }));
      });
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
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                  TextField(
                    controller: cpasswordemailC,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    child: Text('Sign up'),
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
              'Alredy have an account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            CupertinoButton(
                child: Text(
                  'Log in? ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
