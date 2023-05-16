import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/helper/datetime.dart';
import 'package:chat_app/helper/dilouge.dart';
import 'package:chat_app/msgmodel.dart';
import 'package:chat_app/pdffile.dart';
import 'package:chat_app/scrrens/heropage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gallery_saver/gallery_saver.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.mesage});
  final MesaageModel mesage;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    bool isMe = UserData.user.uid == widget.mesage.formId;
    return InkWell(
        onLongPress: () {
          botomSheeet(isMe);
        },
        child: _blueMsg());
  }

  ///for sender
  Widget _blueMsg() {
    bool isMe = UserData.user.uid == widget.mesage.formId;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              widget.mesage.type == Type.text
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Padding(
                          padding: isMe
                              ? EdgeInsets.only(right: 10)
                              : EdgeInsets.only(left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(180, 218, 248, 1),
                              borderRadius: isMe
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))
                                  : BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: isMe
                                  ? EdgeInsets.only(right: 10)
                                  : EdgeInsets.only(left: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  widget.mesage.msg,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Acme"),
                                ),
                              ),
                            ),
                          )),
                    )
                  : Padding(
                      padding: isMe
                          ? EdgeInsets.only(right: 10)
                          : EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HeroWPage(
                              msg: widget.mesage,
                            );
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 180, 218, 248),
                              border: Border.all(
                                  width: 6,
                                  color:
                                      const Color.fromARGB(255, 180, 218, 248)),
                              borderRadius: isMe
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))
                                  : const BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          child: ClipRRect(
                              borderRadius: isMe
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10))
                                  : const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                              child: widget.mesage.type == Type.image
                                  ? CachedNetworkImage(
                                      imageUrl: widget.mesage.msg,
                                      fit: BoxFit.cover,
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Pdffilee(
                                              path: widget.mesage.msg);
                                        }));
                                      },
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                  'assets/p12.jpg')),
                                          Positioned(
                                            top: 80,
                                            child: Text(
                                              maxLines: 2,
                                              widget.mesage.pdfTxt,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontFamily: "Acme"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                        ),
                      ),
                    ),
              Padding(
                padding: isMe
                    ? EdgeInsets.only(right: 10, bottom: 12)
                    : EdgeInsets.only(left: 10, bottom: 12),
                child: Text(
                  MyDateUtill.getFormatTime(widget.mesage.sent),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 180, 218, 248),
                      fontSize: 12,
                      fontFamily: "Acme"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void botomSheeet(bool isSelc) {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(255, 180, 218, 248),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              _OptionItem(
                  icon: const Icon(Icons.copy_all_outlined),
                  name: 'Copy Text',
                  onTap: () async {
                    await Clipboard.setData(
                            ClipboardData(text: widget.mesage.msg))
                        .then((value) {
                      Navigator.pop(context);
                      Diallougs.showSnackBar(context, "Text Copied");
                    });
                  }),
              Column(
                children: [
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          await GallerySaver.saveImage(widget.mesage.msg,
                                  albumName: 'Chat app')
                              .then((value) {
                            Navigator.pop(context);
                            if (value != null && value) {
                              Diallougs.showSnackBar(context, "Image saved !");
                            }
                          });
                        } catch (e) {
                          print('Imageutl:${widget.mesage.msg}');
                        }
                      }),
                  const Divider(
                    color: Colors.black,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _OptionItem(
                      icon: Icon(Icons.delete),
                      name: 'Delelet Message',
                      onTap: () async {
                        await UserData.deleteMessage(widget.mesage)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      }),
                ],
              ),
              //  if (widget.mesage.type == Type.text && isSelc)
              //   _OptionItem(
              //       icon: Icon(Icons.delete),
              //       name: 'Delelet Message',
              //       onTap: () async {
              //         await UserData.deleteMessage(widget.mesage).then((value) {
              //           Navigator.pop(context);
              //         });
              //       }),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
