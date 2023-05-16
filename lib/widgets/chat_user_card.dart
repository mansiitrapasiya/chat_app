import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/datetime.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/msgmodel.dart';
import 'package:chat_app/scrrens/chatpage.dart';
import 'package:chat_app/scrrens/profilephoto.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final Chatuser user;
  ChatUserCard({super.key, required this.user, required this.index});
  int index;

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

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        height: mq.height * .12,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300 + (widget.index * 100)),
        transform: Matrix4.translationValues(
            0, startAnimation ? 0 : MediaQuery.of(context).size.width, 0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return ChatPage(
                    user: widget.user,
                  );
                }));
              },
              child: StreamBuilder(
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list = data
                          ?.map((e) => MesaageModel.fromJson(e.data()))
                          .toList() ??
                      [];
                  if (list.isNotEmpty) {
                    message = list[0];
                  }
                  if (UserData.auth.currentUser == null) {
                    //todo Fix this The mansi in the future
                    return const Text("wtf");
                  }
                  return Hero(
                    tag: widget.user.image,
                    child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(right: 10, left: 10),
                        tileColor: Color.fromARGB(255, 180, 218, 248),
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
                                    message!.formId != UserData.user.uid
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
                                  builder: (_) =>
                                      ProfilePhoto(chatuser: widget.user));
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadiusDirectional.circular(40),
                              child: SizedBox(
                                height: mq.height * .8,
                                width: mq.width * .14,
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))),
                  );
                },
                stream: UserData.getLastmessage(widget.user),
              )),
        ),
      ),
    );
  }
}
