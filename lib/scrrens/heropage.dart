import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/msgmodel.dart';
import 'package:flutter/material.dart';


class HeroWPage extends StatefulWidget {
  final MesaageModel msg;
  const HeroWPage({super.key, required this.msg});

  @override
  State<HeroWPage> createState() => _HeroWPageState();
}

class _HeroWPageState extends State<HeroWPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Hero(
          tag: widget.msg.msg,
          child: CachedNetworkImage(
            imageUrl: widget.msg.msg,
          ),
        ),
      ),
    );
  }
}
