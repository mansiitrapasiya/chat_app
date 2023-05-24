import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/datetime.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/msgmodel.dart';
import 'package:chat_app/scrrens/chatpage.dart';
import 'package:chat_app/scrrens/profilephoto.dart';
import 'package:chat_app/scrrens/profilescrreen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final Chatuser user;
  const ChatUserCard(
      {super.key,
      required this.user,
      required this.index,
      this.isHide = true,
      this.selected = const <int>[],
      this.onChanged});
  final int index;
  final bool isHide;

  final List<int> selected;
  final void Function()? onChanged;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  MesaageModel? message;
  bool startAnimation = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  // List<Chatuser> list = [];
  bool isSelcted() {
    return widget.selected.contains(widget.index);
  }

  selectDeselect() {
    if (isSelcted()) {
      setState(() {
        widget.selected.remove(widget.index);
      });
    } else {
      setState(() {
        widget.selected.add(widget.index);
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!();
    }
  }

  bool isHidee() {
    if (message == null && widget.isHide) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          if (isSelcted())
            Checkbox(
                value: true,
                onChanged: (value) {
                  selectDeselect();
                }),
          Expanded(
            child: InkWell(
                onTap: () {
                  if (widget.selected.isNotEmpty) {
                    selectDeselect();
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ChatPage(
                        user: widget.user,
                      );
                    }));
                  }
                },
                onLongPress: () {
                  selectDeselect();
                },
                child: StreamBuilder(
                  stream: UserData.getLastmessage(widget.user),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    final list = data
                            ?.map((e) => MesaageModel.fromJson(e.data()))
                            .toList() ??
                        [];
                    if (list.isNotEmpty) {
                      message = list[0];
                    }
                    // if (UserData.auth.currentUser == null) {
                    //   //todo Fix this The mansi in the future
                    //   return const Text("wtf");
                    // }

                    return isHidee()
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            child: Hero(
                              tag: widget.user.image,
                              child: ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  tileColor:
                                      const Color.fromARGB(255, 180, 218, 248),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  title: Text(
                                    widget.user.name,
                                    style: const TextStyle(
                                      fontFamily: "Acme",
                                      fontSize: 18,
                                    ),
                                  ),
                                  trailing: message == null
                                      ? null
                                      : message!.read.isEmpty &&
                                              message!.formId !=
                                                  UserData.user.uid
                                          ? Container(
                                              height: 15,
                                              width: 15,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle),
                                            )
                                          : Text(MyDateUtill.getlastTime(
                                              context: context,
                                              time: message!.sent,
                                            )),
                                  subtitle: Text(
                                    message != null
                                        ? message!.type == Type.image
                                            ? 'image'
                                            : message!.msg
                                        : widget.user.about,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontFamily: "Acme",
                                      fontSize: 18,
                                    ),
                                  ),
                                  minLeadingWidth: 60,
                                  leading: InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => ProfilePhoto(
                                                chatuser: widget.user));
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                40),
                                        child: SizedBox(
                                          height: 60,
                                          width: 60,
                                          child: CachedNetworkImage(
                                            imageUrl: widget.user.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))),
                            ),
                          );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
