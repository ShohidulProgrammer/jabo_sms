import 'package:flutter/material.dart';

//mySnackBar(
//    {@required BuildContext context,
//      @required String msg,
//      Color color = Colors.red}) {
//  Fluttertoast.showToast(
//      msg: msg,
//      toastLength: Toast.LENGTH_SHORT,
//      gravity: ToastGravity.BOTTOM,
//      timeInSecForIos: 1,
//      backgroundColor: color,
//      textColor: Colors.white,
//      fontSize: 16.0);
//}

class Snackbar extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  final String msg;
  Snackbar(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: RaisedButton(
        textColor: Colors.red,
        child: Text('Submit'),
        onPressed: () => showSnackbar(context),
      ),
    );
  }

  void showSnackbar(
    BuildContext context,
  ) {
    final snackBar = SnackBar(content: Text(msg));
    globalKey.currentState.showSnackBar(snackBar);
  }
}
