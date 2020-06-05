import 'package:flutter/material.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import 'package:sql_db/utilities/text_style.dart';
import 'package:sql_db/widgets/snackbar.dart';
import '../widgets/massage_buble.dart';

class QueueSmsDetails extends StatefulWidget {
  final smsQueItem;

  QueueSmsDetails({@required this.smsQueItem});

  @override
  _QueueSmsDetailsState createState() => _QueueSmsDetailsState();
}

class _QueueSmsDetailsState extends State<QueueSmsDetails> {
  DatabaseHelper db = DatabaseHelper.db;
  @override
  Widget build(BuildContext context) {
    var smsItem = widget.smsQueItem;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          smsItem.mobileNo,
          style: kBigTitleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              db.deleteAll(table: db.queueTable);
              Navigator.pop(context);
              mySnackBar(
                  context: context, msg: 'All Sms Successfully Deleted!');

              setState(() {
                smsItem = widget.smsQueItem;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return smsItem == null
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Bubble(
                                    message: smsItem.message,
                                    isMe: false,
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
