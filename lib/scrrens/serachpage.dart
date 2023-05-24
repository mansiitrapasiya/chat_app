import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/scrrens/botombarr.dart';

import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';

class SerachPage extends StatefulWidget {
  const SerachPage({super.key});

  @override
  State<SerachPage> createState() => _SerachPageState();
}

class _SerachPageState extends State<SerachPage> {
  List<Chatuser> list = [];
  final List<Chatuser> _serachlist = [];
  bool isSerach = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BotomBarr(navIndex: 0),
              ));
          return true;
        });
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSerach = !isSerach;
                      });
                    },
                    icon: Icon(
                      isSerach ? Icons.close : Icons.search_rounded,
                      color: Color.fromARGB(255, 180, 218, 248),
                    )),
              ),
              backgroundColor: Colors.black,
              title: isSerach
                  ? TextFormField(
                      cursorColor: Color.fromARGB(255, 180, 218, 248),
                      onChanged: (value) {
                        _serachlist.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            _serachlist.add(i);
                          }
                          setState(() {
                            _serachlist;
                          });
                        }
                      },
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 180, 218, 248),
                          )),
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          isSerach = !isSerach;
                        });
                      },
                      child: Text(
                        'Serach',
                        style: TextStyle(
                            color: Color.fromARGB(255, 180, 218, 248),
                            fontFamily: "Acme"),
                      ),
                    )),
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
                  list =
                      data?.map((e) => Chatuser.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: isSerach ? _serachlist.length : list.length,
                        itemBuilder: (context, index) {
                          return ChatUserCard(
                              isHide: false,
                              index: index,
                              user:
                                  isSerach ? _serachlist[index] : list[index]);
                        });
                  } else {
                    return const Center(
                        child: Text(
                      "No result found",
                      style: TextStyle(
                          color: Color.fromARGB(255, 180, 218, 248),
                          fontFamily: "Acme"),
                    ));
                  }
              }
            },
          )),
    );
  }
}
