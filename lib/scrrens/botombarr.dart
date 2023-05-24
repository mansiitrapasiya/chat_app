import 'dart:collection';

import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/dummy.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/scrrens/myhomepage.dart';

import 'package:chat_app/scrrens/serachpage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BotomBarr extends StatefulWidget {
  final int navIndex;
  const BotomBarr({super.key, required this.navIndex});

  @override
  State<BotomBarr> createState() => _BotomBarrState();
}

class _BotomBarrState extends State<BotomBarr> {
  int selectedIndex = 0;
  final ListQueue<int> _navigationQueue = ListQueue();
  DateTime currentBackPressTime = DateTime.now();

  List scrren = [
    MyHomePage(),
    SerachPage(),
    Videoscreen(),
  ];

  void onTapped(int index) {
    setState(() {
      if (index != selectedIndex) {
        _navigationQueue.removeWhere((element) => element == index);
        _navigationQueue.addLast(index);
        selectedIndex = index;
      }
    });
    print(_navigationQueue);
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.navIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigationQueue.isEmpty) {
          DateTime now = DateTime.now();
          if (now.difference(currentBackPressTime) >
              const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Press back again to exit");
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        } else {
          setState(() {
            _navigationQueue.removeLast();
            int lastIndex =
                _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
            selectedIndex = lastIndex;
          });
          print(_navigationQueue);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: scrren[selectedIndex],
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: GNav(
                    activeColor: Color.fromARGB(255, 180, 218, 248),
                    // style: const TextStyle(backgroundColor: Colors.amber),
                    curve: Curves.linear,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    onTabChange: (value) {
                      selectedIndex = value;
                      setState(() {});
                    },
                    textStyle: TextStyle(color: Colors.black),
                    backgroundColor: Colors.grey,
                    tabBorderRadius: 35,
                    color: Colors.white,
                    // activeColor: Colors.black,
                    iconSize: 28,
                    tabBackgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    tabs: const [
                      GButton(
                        iconColor: Color.fromARGB(255, 180, 218, 248),
                        icon: Icons.home,
                      ),
                      GButton(
                        icon: Icons.search,
                      ),
                      GButton(
                        icon: Icons.analytics,
                      ),
                    ])),
          ),
        ),
      ),
    );
  }
}
