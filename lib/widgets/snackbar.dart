import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mySnackBar(
    {@required BuildContext context,
    @required String msg,
    Color color = Colors.red}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
