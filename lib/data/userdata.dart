import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/model.dart';
import 'package:chat_app/msgmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;

class UserData {
  static User get user => auth.currentUser!;

  static FirebaseAuth auth = FirebaseAuth.instance;
  static late Chatuser mee;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
////===========messaging token//////////////////

  static Future<void> getFirebaseMsg() async {
    await fmessaging.requestPermission();
    await fmessaging.getToken().then((t) {
      if (t != null) {
        mee.pushToken = t;
      }
    });
  }

  //============for sending push ====================================
  static FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  static Future<void> sendNotification(Chatuser chatuser, String msg) async {
    try {
      final body = {
        "to": chatuser.pushToken,
        "notification": {"title": UserData.mee.name, "body": msg},
      };

      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA4HOtRc0:APA91bGAHuBiIi4vAdWZ9WvuodnalAgrvTHdAasl9DrJtTejM8ztYkuTFiB2AbqdHYVyfzn9PCeIIG60-faLWmk0N-kM4zvxmMW24hLZbv1JyTEPC2Oa1KVTzXftBWKAgkncsC_dzQGe'
              },
              body: jsonEncode(body));
      if (response.statusCode == 200) {
        print("noti success");
      } else {
        print(response.body);
        print("fail fail fail!!!");
      }
    } catch (e) {
      log('mdksndkjbvksdvb sm msv mc mn ns;kv$e');
    }
  }

//==================for checking user is exist or noy===================
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for store currentUserInfo
  //for getting current user info
  static Future<void> currentUserInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        mee = Chatuser.fromJson(user.data()!);
        await getFirebaseMsg();
        updateActiveProfile(true);
      } else {
        await createuser().then((value) => currentUserInfo());
      }
    });
  }

  static Future<void> createuser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatuser = Chatuser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: user.uid,
        email: user.email.toString(),
        pushToken: '');
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatuser.toJson());
  }

  static Future<void> updateProfile(File file) async {
    ////getting file extention
    final ext = file.path.split('.').last;
    final ref = storage.ref().child("profile_picture/${user.uid}.");
    //ulpading image
    ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      //update image in firebase
      mee.image = await ref.getDownloadURL();
      await firestore.collection('users').doc(user.uid).update({
        'image': mee.image,
      });
    });
  }

  //for getting all users from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAlluser() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  ///============================for chat screen ===================================///
  ///  useful converstation id//////
  static String getConversation(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllmessage(
      Chatuser user) {
    return firestore
        .collection("chats/${getConversation(user.id)}/messages/")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMsg(Chatuser chatuser, String msg, Type type,String pdfName) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MesaageModel messagee = MesaageModel(
        formId: user.uid,
        pdfTxt: pdfName,
        msg: msg,
        read: '',
        told: chatuser.id,
        sent: time,
        type: type);

    final ref =
        firestore.collection("chats/${getConversation(chatuser.id)}/messages");
    await ref.doc(time).set(messagee.toJson()).then(
          (value) =>
              sendNotification(chatuser, type == Type.text ? msg : 'image'),
        );
  }

  ///---------------------get last msg-----------------------//
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastmessage(
      Chatuser user) {
    return firestore
        .collection("chats/${getConversation(user.id)}/messages")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  //====================chatimage======

  static Future<void> chatImage(Chatuser chatuser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        "profile_picture/${getConversation(chatuser.id)}/${DateTime.now().microsecondsSinceEpoch}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) async {
      //update image in firebase
      final imagUrl = await ref.getDownloadURL();
      await sendMsg(chatuser, imagUrl, Type.image,"");
    });
  }

static Future<void> chatPdf(Chatuser chatuser, File file, String pdfName ) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        "pdf/${getConversation(chatuser.id)}/${DateTime.now().microsecondsSinceEpoch}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'document/$ext'))
        .then((p0) async {
          
      //update image in firebase
      final imagUrl = await ref.getDownloadURL();
      await sendMsg(chatuser, imagUrl, Type.pdf,pdfName);
    });
  }

  //===========================auser active or not=========
  static Future<void> updateActiveProfile(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'push_token': mee.pushToken,
    });
  }

//-----for hetting specific user info--------------////////////

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      Chatuser chatuser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatuser.id)
        .snapshots();
  }

  //-----------------delete message--------------/
  static Future<void> deleteMessage(MesaageModel message) async {
    await firestore
        .collection('chats/${getConversation(message.told)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }


    //================for add particular user====================

  // static Future<bool> addChatUser(String email) async {
  //   final data = await firestore
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   log('data===========${data.docs}');

  //   if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
  //     log('user exist===============${data.docs.first.data()}');
  //     firestore
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('my_users')
  //         .doc(data.docs.first.id)
  //         .set({});
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

// static Stream<QuerySnapshot<Map<String, dynamic>>> getAMyuserid() {
//     return firestore
//         .collection("users").doc(user.uid)
//         .collection('my_my_users')
//         .snapshots();
//   }
}
