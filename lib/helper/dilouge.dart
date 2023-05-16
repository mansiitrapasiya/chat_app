import 'package:flutter/material.dart';

class Diallougs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
      content: Text(msg),
      backgroundColor: Colors.grey,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) =>const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
