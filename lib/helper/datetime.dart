import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as ago;

class MyDateUtill {
  static String getFormatTime(String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return DateFormat('h:mm a').format(date);
  }

  static String getlastTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear
        ? '${sent.day}${_getmonth(sent)} ${sent.year}'
        : '${sent.day}${_getmonth(sent)}';
  }

  static String _getmonth(DateTime date) {
    switch (date.month) {
      case 1:
        return ' Jan';
      case 2:
        return ' Feb';
      case 3:
        return ' March';
      case 4:
        return ' April';
      case 5:
        return ' May';
      case 6:
        return ' Jun';
      case 7:
        return ' July';
      case 8:
        return ' Aug';
      case 9:
        return ' Spte';
      case 10:
        return ' Oct';
      case 11:
        return ' Nov';
      case 12:
        return ' Dec';
    }
    return "NA";
  }

  //----------get last active time of user-----------------------------------------------///////////
  static String getLastActive(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;
    if (i == -1) return 'Last seen not avilable';
    DateTime time = DateTime.fromMicrosecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('hh:mm a').format(time);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }
    if ((now.difference(time).inHours / 24.round() == 1)) {
      return 'Last seen yestrday at $formattedTime';
    }
    String month = _getmonth(time);
    return 'Last seen at ${time.day}$month on $formattedTime';
    // return ago.format(time);
  }
}
