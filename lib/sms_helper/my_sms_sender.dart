import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/model/sms_history_model.dart';
import '../db/model/sms_queue_model.dart';

class MySmsSender {
  static const smsChannel = const MethodChannel('smsChannel');

  static sendSms({@required SmsQueueModel que}) async {
    try {
      // call kotlin platform function for sending sms
      var result = await smsChannel.invokeMethod('sendSMS', {
        "mobileNo": que.mobileNo,
        "userName": que.userName,
        "msg": que.message,
        "send": -1,
        "id": que.id
      });
      print('Send Result : $result');
    } on PlatformException catch (e) {
      print('Failed to Send Sms. Error: ${e.message}');
    }
  }

  static reSendSms({@required SmsHistoryModel history}) async {
    try {
      // call kotlin platform function for sending sms
      await smsChannel.invokeMethod('sendSMS', {
        "mobileNo": history.mobileNo,
        "userName": history.userName,
        "msg": history.message,
        "send": 0,
        "id": history.id
      });
    } on PlatformException catch (e) {
      print('Failed to ReSend Sms. Error: ${e.message}');
    }
  }
}
