import 'package:flutter/material.dart';
import 'package:ideasms/bloc/history_bloc.dart';
import 'package:ideasms/utilities/get_time.dart';
import '../db/model/sms_history_model.dart';
import '../widgets/sms_history_list.dart';
import '../sms_helper/my_sms_sender.dart';
import '../db/utils/db_helper.dart';
import '../utilities/text_style.dart';
import '../widgets/massage_buble.dart';

DatabaseHelper dbHelper = DatabaseHelper.db;


class SmsHistoryDetails extends StatelessWidget {
  Future<List<SmsHistoryModel>> _listFuture;
  final String mobile;
  SmsHistoryDetails({@required this.mobile});
  final HistoryBloc historyBloc = HistoryBloc();
  final globalKey = GlobalKey<ScaffoldState>();

//
//  Future<bool> _onWillPop() {
//    return Navigator.pushAndRemoveUntil(
//          context,
//          MaterialPageRoute(
//              builder: (BuildContext context) => SmsHistoryList()),
//          (Route<dynamic> route) => false,
//        ) ??
//        false;
//  }

  @override
  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: _onWillPop,
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          mobile,
          style: kBigTitleTextStyle,
        ),
        actions: <Widget>[
//          // Refresh History List View
//          IconButton(
//            icon: Icon(Icons.refresh),
//            onPressed: () {
////              refreshList();
//            },
//          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              String title = 'Confirm deletion';
              String desc = 'Are you sure to delete all these messages?';
              myAlertDialog(
                  context: context,
                  title: title,
                  desc: desc,
                  mobile: mobile);
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
                  child: FutureBuilder<List<SmsHistoryModel>>(
                      future: _listFuture,
                      builder: (context,
                          AsyncSnapshot<List<SmsHistoryModel>> snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.data.length <= 0) {
                          return Center(child: Text('No SMS'));
                        } else if (snapshot.hasError) {
                          debugPrint('Snap Shot Data: ${snapshot.data}');
                          return Center(child: Text('There was an error'));
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              SmsHistoryModel smsHistoryItem =
                                  snapshot.data[index];

                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        getTime(dateTime: smsHistoryItem.date),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 9),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: smsHistoryItem.send
                                              ? SizedBox(
                                                  width: 0.0,
                                                  height: 0.0,
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    MySmsSender.reSendSms(
                                                        history:
                                                            smsHistoryItem);
                                                    showSnackbar(
                                                        context, 'SMS ReSend!');
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
                                            message: smsHistoryItem.message,
                                            isMe: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(child: Text('No Value yet'));
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

//  @override
//  void initState() {
//    super.initState();
//    setState(() {
//      // initial List load
//      _listFuture = dbHelper.getAllMessageHistory(mobile: widget.mobile);
//    });
//  }

//  Widget refreshList() {
//    // reload
//    setState(() {
//      _listFuture = dbHelper.getAllMessageHistory(mobile: widget.mobile);
////      showSnackbar(context, 'Successfully Refresh!');
//    });
//  }

  Future<void> myAlertDialog(
      {BuildContext context,
      String title,
      String desc,
      VoidCallback okFun,
      String mobile}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(desc),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                historyBloc.deleteMassages(
                    table: dbHelper.historyTable, mobile: mobile);
                showSnackbar(context, 'Massages are successfully deleted!!');

                Navigator.of(context).pop();
//                refreshList();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    globalKey.currentState.showSnackBar(snackBar);
  }
}
