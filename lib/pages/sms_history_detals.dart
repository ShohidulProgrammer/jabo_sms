import 'package:flutter/material.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import 'package:sql_db/sms_helper/my_sms_sender.dart';
import 'package:sql_db/utilities/text_style.dart';
import 'package:sql_db/widgets/snackbar.dart';
import '../widgets/massage_buble.dart';
import '../utilities/date_formatter.dart' as duration;

class SmsHistoryDetails extends StatefulWidget {
  final smsItem;
  final String date;

  // final DateTime now = smsItem.date;
  SmsHistoryDetails({@required this.smsItem, this.date = ""});

  @override
  _SmsHistoryDetailsState createState() => _SmsHistoryDetailsState();
}

class _SmsHistoryDetailsState extends State<SmsHistoryDetails> {
  bool successfulySend;

  @override
  void initState() {
    super.initState();
    setState(() {
      successfulySend = widget.smsItem.send;
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper.db;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.smsItem.mobileNo,
          style: kBigTitleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              dbHelper.deleteMassageItem(
                  table: dbHelper.historyTable,
                  mobile: widget.smsItem.mobileNo);
              Navigator.pop(context);
              mySnackBar(
                  context: context, msg: 'Massage successfully deleted!');
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
                      return widget.smsItem == null
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    widget.date,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: successfulySend
                                            // widget.smsItem.send
                                            ? SizedBox(
                                                width: 0.0,
                                                height: 0.0,
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  mySnackBar(
                                                      context: context,
                                                      msg:
                                                          'Resend button clicked!');
                                                  setState(() {
                                                    successfulySend =
                                                        widget.smsItem.send;
                                                  });
                                                },
                                                tooltip: 'Resend Sms',
                                                icon: Icon(
                                                  Icons.redo,
                                                  color: Colors.red,
                                                ),
                                              ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Bubble(
                                          message: widget.smsItem.message ,
                                          isMe: false,
                                        ),
                                      ),
                                    ],
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
