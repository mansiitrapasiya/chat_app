import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              color: Colors.grey,
              child: Row(children: [
                const Flexible(
                    child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Message', border: InputBorder.none),
                )),
                IconButton(onPressed: () {}, icon: Icon(Icons.send))
              ]),
            )
          ],
        ),
      )),
    );
  }
}
