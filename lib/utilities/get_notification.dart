import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ideasms/sms_helper/make_ready_to_send_sms.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();
int i=0;


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

  _fcm.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
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
//    Future.delayed(const Duration(seconds: 5), () {
////      setState(() {
////        refreshList();
////      });
//    });
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
    makeReadyToSendSms( url: url);
//        oldNotifyTime =
//      }
  } else {
    print("This is not a data message");
  }

//    Future.delayed(const Duration(seconds: 6), () {
//      setState(() {
//        refreshList();
//      });
//    });

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