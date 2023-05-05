import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/serachpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyHomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyHomePage(
      {super.key, required this.firebaseUser, required this.userModel});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SerachPAge(
              userModel: widget.userModel,
              firbaseUser: widget.firebaseUser,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(child: Container()),
    );
  }
}
