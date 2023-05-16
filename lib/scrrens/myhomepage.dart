import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/dilouge.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/noti.dart';
import 'package:chat_app/scrrens/profilescrreen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Chatuser> list = [];

  @override
  void initState() {
    super.initState();
    UserData.currentUserInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume'))
        UserData.updateActiveProfile(true);
      if (message.toString().contains('pause'))
        UserData.updateActiveProfile(false);

      return Future.value(message);
    });
    CustomNotification().requesnotificationPermission();
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Color.fromARGB(255, 180, 218, 248),
        //   onPressed: () {
        //     _addChatUserDialog();
        //   },
        //   child: Icon(
        //     Icons.message,
        //     color: Colors.black,
        //   ),
        // ),
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfileScrreen(user: UserData.mee);
                    }));
                  },
                  child: const Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 180, 218, 248),
                  )),
            )
          ],
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Hero(
                    tag: UserData.user.photoURL.toString(),
                    child: CachedNetworkImage(
                      imageUrl: UserData.user.photoURL.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Hero(
                tag: UserData.user.displayName.toString(),
                child: Text(
                  UserData.user.displayName.toString(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 180, 218, 248),
                      fontFamily: "Acme"),
                ),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: UserData.getAlluser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => Chatuser.fromJson(e.data())).toList() ??
                    [];
                if (list.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(index: 0, user: list[index]);
                      });
                } else {
                  return const Center(
                      child: Text(
                    "No result found",
                    style: TextStyle(
                      color: Color.fromARGB(255, 180, 218, 248),
                    ),
                  ));
                }
            }
          },
        ));
  }

  // void _addChatUserDialog() {
  //   String email = '';

  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             backgroundColor: Colors.black,
  //             contentPadding: const EdgeInsets.only(
  //                 left: 24, right: 24, top: 20, bottom: 10),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //             title: Row(
  //               children: const [
  //                 Icon(
  //                   Icons.person_add,
  //                   color: Color.fromARGB(255, 180, 218, 248),
  //                   size: 28,
  //                 ),
  //                 Text('  Add User',
  //                     style: TextStyle(
  //                         color: Color.fromARGB(255, 180, 218, 248),
  //                         fontSize: 16,
  //                         fontFamily: "Acme"))
  //               ],
  //             ),
  //             content: TextFormField(
  //               maxLines: null,
  //               onChanged: (value) => email = value,
  //               decoration: InputDecoration(
  //                   focusedBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(
  //                     color: Color.fromARGB(255, 180, 218, 248),
  //                   )),
  //                   fillColor: Color.fromARGB(255, 180, 218, 248),
  //                   filled: true,
  //                   hintText: 'Email Id',
  //                   prefixIcon: const Icon(Icons.email, color: Colors.black),
  //                   border: OutlineInputBorder(
  //                       borderSide: BorderSide(
  //                         color: Color.fromARGB(255, 180, 218, 248),
  //                       ),
  //                       borderRadius: BorderRadius.circular(15))),
  //             ),
  //             actions: [
  //               MaterialButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('Cancel',
  //                       style: TextStyle(
  //                           color: Color.fromARGB(255, 180, 218, 248),
  //                           fontSize: 16,
  //                           fontFamily: "Acme"))),
  //               MaterialButton(
  //                   onPressed: () async {
  //                     Navigator.pop(context);
  //                     if (email.isNotEmpty) {
  //                       await UserData.addChatUser(email).then((value) {
  //                         if (!value) {
  //                           Diallougs.showSnackBar(
  //                               context, 'User does not Exists!');
  //                         }
  //                       });
  //                     }
  //                   },
  //                   child: const Text(
  //                     'Add',
  //                     style: TextStyle(
  //                         color: Color.fromARGB(255, 180, 218, 248),
  //                         fontSize: 16,
  //                         fontFamily: "Acme"),
  //                   ))
  //             ],
  //           ));
  // }
}
