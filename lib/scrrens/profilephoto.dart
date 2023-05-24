import 'package:chat_app/model.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({super.key, required this.chatuser});
  final Chatuser chatuser;

  @override
  State<ProfilePhoto> createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      // alignment: Alignment.topCenter,
      scale: 0.7,
      child: Dialog(
        
        child: Hero(
          tag: widget.chatuser.image,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      widget.chatuser.image,
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    gradient: LinearGradient(colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.5),
                    ], begin: Alignment.topLeft, end: Alignment.topRight),
                  ),
                  child: Center(
                    child: Text(
                      widget.chatuser.name,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Acme"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
