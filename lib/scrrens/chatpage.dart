import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/datetime.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/msgmodel.dart';
import 'package:chat_app/scrrens/particularusers.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final Chatuser user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List abc = [];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ParticularUser(user: widget.user);
                  }));
                },
                child: StreamBuilder(
                  stream: UserData.getUserInfo(widget.user),
                  builder: (context, snapshot) {
                    final data = snapshot.data?.docs;
                    final list = data
                            ?.map((e) => Chatuser.fromJson(e.data()))
                            .toList() ??
                        [];

                    return Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Color.fromARGB(255, 180, 218, 248),
                            )),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: list.isNotEmpty
                                    ? list[0].image
                                    : widget.user.image),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list.isNotEmpty
                                    ? list[0].name
                                    : widget.user.name,
                                style: const TextStyle(
                                  fontFamily: "Acme",
                                  color: Color.fromARGB(255, 180, 218, 248),
                                ),
                              ),
                              Text(
                                list.isNotEmpty
                                    ? list[0].isOnline
                                        ? 'Online'
                                        : MyDateUtill.getLastActive(
                                            context: context,
                                            lastActive: list[0].lastActive)
                                    : MyDateUtill.getLastActive(
                                        context: context,
                                        lastActive: widget.user.lastActive),
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 180, 218, 248),
                                    fontFamily: "Acme"),
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 80),
                        //     child: IconButton(
                        //         onPressed: () {
                        //           Navigator.push(context,
                        //               MaterialPageRoute(builder: (context) {
                        //             return ParticularUser(user: UserData.mee);
                        //           }));
                        //         },
                        //         icon: Icon(Icons.person)),
                        //   ),
                        // )
                      ],
                    );
                  },
                )),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: UserData.getAllmessage(widget.user),
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
                        // log('Data :${jsonEncode(data![0].data())}');
                        // list = data
                        //         ?.map((e) => Chatuser.fromJson(e.data()))
                        //         .toList() ??
                        //     [];
                        // final _list = ['nbdcskjc', 'nckdjcn'];
                        List<MesaageModel> _list = data
                                ?.map((e) => MesaageModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onLongPress: () {
                                    if (abc.isEmpty) {
                                      abc.add(_list[index]);

                                      log("--------------------${abc.length}");
                                    } else {
                                      if (abc.contains(_list[index])) {
                                        abc.remove(_list[index]);
                                      }
                                    }
                                  },
                                  onTap: () {
                                    if (abc.contains(_list[index])) {
                                      abc.remove(_list[index]);
                                      log("--------------------${abc.length}");
                                    } else {
                                      if (abc.isNotEmpty) {
                                        abc.add(_list[index]);
                                        log("--------------------${abc.length}");
                                      }
                                    }
                                  },
                                  child: Container(
                                    color: abc.contains(_list[index])
                                        ? Colors.amber
                                        : Colors.transparent,
                                    child: MessagePage(
                                      mesage: _list[index],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                              child: Text(
                            "Say Hi..",
                            style: TextStyle(
                                color: Color.fromARGB(255, 180, 218, 248),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ));
                        }
                    }
                  },
                ),
              ),
              _chatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Color.fromARGB(255, 180, 218, 248),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextFormField(
                      controller: textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                      autofocus: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowedExtensions: ['pdf'],
                              type: FileType.custom);

                      if (result != null) {
                        // File file = File(result.files.single.path!);
                        log(result.files.first.name);
                        await UserData.chatPdf(
                            widget.user,
                            File(result.files.single.path!),
                            result.files.first.name);
                      }
                    },
                    child: Icon(Icons.attach_file_outlined)),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        await UserData.chatImage(widget.user, File(image.path));
                      }
                    },
                    child: Icon(Icons.camera_alt_outlined)),
              const  SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        await UserData.chatImage(widget.user, File(image.path));
                      }
                    },
                    child: Icon(Icons.image)),
               const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        MaterialButton(
          height: 46.0,
          color: const Color.fromARGB(255, 180, 218, 248),
          shape: const CircleBorder(),
          minWidth: 0,
          onPressed: () {
            if (textController.text.isNotEmpty) {
              UserData.sendMsg(widget.user, textController.text, Type.text, "");
              textController.text = '';
            }
          },
          child: const Icon(Icons.send, color: Colors.black),
        )
      ],
    );
  }
}
