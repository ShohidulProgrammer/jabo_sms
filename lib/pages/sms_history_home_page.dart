import 'package:flutter/material.dart';
import '../widgets/sms_history_list.dart';

class SmsHistoryHomePage extends StatefulWidget {
  @override
  _SmsHistoryHomePageState createState() => _SmsHistoryHomePageState();
}

class _SmsHistoryHomePageState extends State<SmsHistoryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sms History List'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.delete_forever),
        //     onPressed: () {
        //       for (var i = 0; i < 50; i++) {
        //         deleteHistorySms(
        //           context: context,
        //           id: i,
        //           mobile: "01944700",
        //         );
        //       }
        //     },
        //   ),
        // ],
      ),
      body: SmsHistoryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {}, // makeReadyToSendSms(context),
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
