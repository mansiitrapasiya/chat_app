import 'package:chat_app/models/firebasehelper.dart';
import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/completprofile.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/pages/myhome.dart';
import 'package:chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  User? currentUser=FirebaseAuth.instance.currentUser;
  if(currentUser!=null){
    UserModel?thisUserModel=await FirebaseHelper.getUserbyId(currentUser.uid);
    if(thisUserModel!=null){
    runApp(MyAppLoggedin(firebaseUser: currentUser, userModel: thisUserModel));

    }

  }else{
  runApp(const MyApp());

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
class MyAppLoggedin extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedin({super.key,required this.firebaseUser,required this.userModel});


  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(userModel: userModel,firebaseUser: firebaseUser,),
    );
  }
}
