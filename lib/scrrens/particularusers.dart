import 'dart:io';

import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/datetime.dart';
import 'package:chat_app/helper/dilouge.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/splash.dart';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class ParticularUser extends StatefulWidget {
  final Chatuser user;
  const ParticularUser({super.key, required this.user});

  @override
  State<ParticularUser> createState() => _ParticularUserState();
}

class _ParticularUserState extends State<ParticularUser> {
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Joined on :  ",
            style: TextStyle(color: Colors.white, fontFamily: "Acme"),
          ),
          Text(
            MyDateUtill.getlastTime(
                context: context, time: widget.user.createdAt, showYear: true),
            style: TextStyle(color: Colors.white, fontFamily: "Acme"),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15, top: 10),
            child: InkWell(
              onTap: () async {
                Diallougs.showProgressBar(context);
                await UserData.auth.signOut().then(
                  (value) async {
                    await GoogleSignIn().signOut().then((value) {
                      //for hinding progress dialouge
                      Navigator.pop(context);
                      //for moving home screen
                      Navigator.pop(context);

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Splashscreen();
                      }));
                    });
                  },
                );
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                    fontFamily: "Acme",
                    color: Color.fromARGB(255, 180, 218, 248),
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: widget.user.image,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.user.image),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.user.email,
                style: const TextStyle(
                    color: Colors.white, fontFamily: "Acme", fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Name :  ",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Acme", fontSize: 16),
                ),
                Text(
                  widget.user.name,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Acme", fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
