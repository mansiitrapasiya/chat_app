import 'package:chat_app/scrrens/botombarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Dummy extends StatefulWidget {
  // final int navIndex;
  const Dummy({super.key,});

  @override
  State<Dummy> createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        
        return Future(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>const BotomBarr(navIndex: 0),
              ));
          return true;
        });
      },
      child: Scaffold(
        body: Column(
          children: [Text('data')],
        ),
      ),
    );
  }
}
