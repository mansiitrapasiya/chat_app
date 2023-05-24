import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/noti.dart';
import 'package:chat_app/scrrens/newscrren.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> selected = [];
  List<Chatuser> list = [];
  bool isLoaded = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      isLoaded = false;
    });
    await UserData.currentUserInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        UserData.updateActiveProfile(true);
      }
      if (message.toString().contains('pause')) {
        UserData.updateActiveProfile(false);
      }

      return Future.value(message);
    });
    await CustomNotification().requesnotificationPermission();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return isLoaded
        ? SafeArea(
            child: Scaffold(
              
                backgroundColor: const Color.fromARGB(255, 8, 8, 8),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: UserData.getAlluser(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return Center(
                                child: getShimmerLoading(),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              return NewScrren(
                                data: data,
                              );
                          }
                        },
                      ),
                    ],
                  ),
                )),
          )
        : getShimmerLoading();
  }

  Widget getShimmerLoading() {
    return Center(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              child: SizedBox(
                height: 48,
                child: ColoredBox(color: Colors.white),
              ),
              baseColor: Color.fromARGB(255, 180, 218, 248),
              highlightColor: Colors.white);
        },
      ),
    );
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
