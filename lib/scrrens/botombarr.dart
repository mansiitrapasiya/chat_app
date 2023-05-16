import 'package:chat_app/data/userdata.dart';
import 'package:chat_app/dummy.dart';
import 'package:chat_app/model.dart';
import 'package:chat_app/scrrens/myhomepage.dart';

import 'package:chat_app/scrrens/serachpage.dart';

import 'package:flutter/material.dart';

class BotomBarr extends StatefulWidget {
  final int navIndex;
  const BotomBarr({super.key, required this.navIndex});

  @override
  State<BotomBarr> createState() => _BotomBarrState();
}

class _BotomBarrState extends State<BotomBarr> {
  List scrren = [MyHomePage(), SerachPage(), Dummy()];
  void _botomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.navIndex;
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: scrren[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromARGB(255, 180, 218, 248),
            backgroundColor: Colors.black,
            onTap: _botomBar,
            currentIndex: selectedIndex,
            // unselectedFontSize: 0,
            // selectedFontSize: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 180, 218, 248),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 180, 218, 248),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.tram_sharp,
                    color: Color.fromARGB(255, 180, 218, 248),
                  ),
                  label: ""),
            ]));
  }
}
