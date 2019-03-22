import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ShowSnackBar {
  static void show(
      BuildContext context, String title, String message, int time) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      title: title,
      message: message,
      duration: Duration(seconds: time),
    )..show(context);
  }
}
