import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../sms_helper/make_ready_to_send_sms.dart';
import '../db/model/sms_history_model.dart';
import '../db/utils/db_helper.dart';
import '../utilities/list_separator.dart';
import '../widgets/sms_history_list_item.dart';


DatabaseHelper dbHelper = DatabaseHelper.db;

class SmsHistoryList extends StatefulWidget {
  final String appTitle = 'SMS history';

  @override
  _SmsHistoryListState createState() => _SmsHistoryListState();
}

class _SmsHistoryListState extends State<SmsHistoryList> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  Future<List<SmsHistoryModel>> _listFuture;

  int i = 0;

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: <Widget>[
          // Refresh History List View
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              refreshList();
            },
          ),
          // Delete All Data from History table
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              String title = 'Confirm deletion';
              String desc = 'Are you sure to delete all these messages?';
              myAlertDialog(
                context: context,
                title: title,
                desc: desc,
              );
            },
          ),
        ],
      ),
      body: Container(
        child: _buildSmsHistoryList(context),
      ),
    );
  }

  Widget _buildSmsHistoryList(BuildContext context) {
    return FutureBuilder<List<SmsHistoryModel>>(
//        future: dbHelper.getAllHistories(),
        future: _listFuture ?? [],
        builder: (context, AsyncSnapshot<List<SmsHistoryModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length <= 0) {
            return Center(child: Text('No SMS'));
          } else if (snapshot.hasError) {
            debugPrint('Snap Shot Data: ${snapshot.data}');
            return Center(child: Text('There was an error'));
          } else if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length ?? 0,
              itemBuilder: (_, int index) {
                SmsHistoryModel smsHistoryItem = snapshot.data[index] ?? 0;
                return historyListItem(
                  smsHistory: smsHistoryItem,
                  child: SmsHistoryItemWidget(
                    smsHistory: smsHistoryItem,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  kListSparatorDivider(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

// sms history list item
  Widget historyListItem({SmsHistoryModel smsHistory, Widget child}) {
    return Slidable(
      child: child,
      actionPane: SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        //  delete List  item
        IconSlideAction(
            key: UniqueKey(),
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              dbHelper.deleteMassages(
                  table: dbHelper.historyTable, mobile: smsHistory.mobileNo);
              showSnackbar(context, 'Massages are successfully deleted!');
              setState(() {
                refreshList();
              });
            }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // notification handle on foreground state
    getNotification();
    // permission for showing notification on status bar for ios
    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    // initial List load
    _listFuture = dbHelper.getAllMobileHistories();
  }

  // rebuild any time when coming to this page
  @override
  void didChangeDependencies() {
    refreshList();
    print('didChangeDependencies was called');

    super.didChangeDependencies();
  }




  refreshList() {
    // reload
    setState(() {
      _listFuture = dbHelper.getAllMobileHistories();
    });
//    showSnackbar(context, 'Successfully Refresh!');
  }

  Future<dynamic> _handleNotification(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      var data = message['data'] ?? message;
      String url = data['url'];
      print('\nUrl ${++i} : $url');
      if (url != '') {
        // send sms
        makeReadyToSendSms(url: url);
      }

      url = '';
      message.clear();
      print('Message: $message URL: $url');
    } else {
      print("This is not a data message");
    }
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        refreshList();
      });
    });
  }

  Future<dynamic> _notificationTapHandler(Map<String, dynamic> message) async {
    String newNotifyTime, oldNotifyTime;
    if (message.containsKey('data')) {
      // Handle data message
      var data = message['data'] ?? message;
      String url = data['url'];
//      time = data['google.sent_time'];
      print(
          '\nData Message received by Taping status bar! \nUrl ${++i} : $url');
//      if () {
      // send sms
      makeReadyToSendSms(url: url);
//        oldNotifyTime =
//      }
    } else {
      print("This is not a data message");
    }

    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        refreshList();
      });
    });

    // Or do other work.
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  void getNotification() {
    _fcm.configure(
      onMessage: _handleNotification,
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
//      onBackgroundMessage:  myBackgroundMessageHandler,

//      onLaunch: _handleNotification,
//      onResume: _handleNotification,
    );
  }

  Future<void> myAlertDialog({
    BuildContext context,
    String title,
    String desc,
  }) async {
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
                dbHelper.deleteAll(table: dbHelper.historyTable);
                showSnackbar(context, 'All Sms History Deleted successfully!');
                refreshList();
                Navigator.of(context).pop();
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
