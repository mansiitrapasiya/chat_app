import 'package:chat_app/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
 static Future<UserModel?> getUserbyId(String uid) async {
    UserModel? usermodel;
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (documentSnapshot.data() != null) {
      usermodel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return usermodel!;
  }
}
