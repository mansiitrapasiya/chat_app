import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/dilouge.dart';
import 'package:chat_app/scrrens/botombarr.dart';
import 'package:chat_app/scrrens/myhomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double size = 0.6;
  bool isShowBottom = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        size = 1;
      });
    });
    Timer(const Duration(seconds: 2), () async {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => MyHomePage()
            ));
      } else {
        setState(() {
          isShowBottom = true;
        });
      }
    });
  }

  _handelGoogleClick() {
    Diallougs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if (await UserData.userExist()) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MyHomePage();
          }));
        } else {
          UserData.createuser().then((value) => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) {
                return MyHomePage();
              })));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await UserData.auth.signInWithCredential(credential);
    } catch (e) {
      Diallougs.showSnackBar(context, 'Check YOur Internet Connection,s');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              Center(
                child: AnimatedPadding(
                  duration: Duration(seconds: 1),
                  padding: EdgeInsets.only(
                      left: 8, right: 8, bottom: isShowBottom ? 200 : 0),
                  child: AnimatedScale(
                      duration: Duration(seconds: 1),
                      scale: size,
                      child: Lottie.asset(
                        'assets/splash.json',
                      )),
                ),
              ),
              AnimatedScale(
                duration: Duration(seconds: 1),
                scale: isShowBottom ? 1 : 0,
                alignment: Alignment.bottomCenter,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Color(0xff454545),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 25, top: 15, bottom: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WELCOME !',
                            style: TextStyle(
                                fontFamily: "Acme",
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(
                              textAlign: TextAlign.justify,
                              'Chat system is a peer-to-peer system where the users exchange text messages and files between the system\'s users',
                              style: TextStyle(
                                  fontFamily: "Acme",
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(double.infinity, 50),
                                    )),
                                onPressed: () {
                                  _handelGoogleClick();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/p3.png',
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    const Text('Continue with google',
                                        style: TextStyle(
                                            fontFamily: 'Acme',
                                            fontSize: 16,
                                            color: Colors.black)),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
