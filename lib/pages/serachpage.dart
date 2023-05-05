import 'package:chat_app/models/model.dart';
import 'package:chat_app/pages/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SerachPAge extends StatefulWidget {
  final UserModel userModel;
  final User firbaseUser;
  const SerachPAge(
      {super.key, required this.firbaseUser, required this.userModel});

  @override
  State<SerachPAge> createState() => _SerachPAgeState();
}

class _SerachPAgeState extends State<SerachPAge> {
  TextEditingController emailContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Serach ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: emailContoller,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    child: Text('Serach'),
                    onPressed: () {
                      setState(() {});
                    },
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where("email", isEqualTo: emailContoller.text)
                          .where("email", isNotEqualTo: widget.userModel.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                                snapshot.data as QuerySnapshot;

                            if (dataSnapshot.docs.length > 0) {
                              Map<String, dynamic> userMap =
                                  dataSnapshot.docs[0].data()
                                      as Map<String, dynamic>;

                              UserModel searchedUser =
                                  UserModel.fromMap(userMap);

                              return ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatRoom();
                                  }));
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(searchedUser.profile!),
                                ),
                                title: Text(searchedUser.fullName!),
                                subtitle: Text(searchedUser.email!),
                              );
                            } else {
                              return Text("No results found!");
                            }
                          } else if (snapshot.hasError) {
                            return Text("An error occured!");
                          } else {
                            return Text("No results found!");
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ],
              ),
            ),
          ),
        ));
  }
}
