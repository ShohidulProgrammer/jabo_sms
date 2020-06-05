import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../http_helper/check_interner_connectivity.dart';
import '../sms_helper/make_ready_to_send_sms.dart';
import '../widgets/sms_queue_list.dart';

class SmsQueueHomePage extends StatefulWidget {
  @override
  _SmsQueueHomePageState createState() => _SmsQueueHomePageState();
}

class _SmsQueueHomePageState extends State<SmsQueueHomePage> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      getWebDataIfInternetAvailable();
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sms Queue List'),
      ),
      body: SmsQueueList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          makeReadyToSendSms(context);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
