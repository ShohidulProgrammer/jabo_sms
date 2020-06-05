import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_db/db/model/sms_queue_model.dart';


class MySmsSender {
  static const smsChannel = const MethodChannel('smsChannel');

  static sendSms({@required SmsQueueModel que}) async {
    try {

      print('\nQueue ID: ${que.id}');
      // call kotlin platform function for sending sms
      var result = await smsChannel
          .invokeMethod('sendSMS', {"mobileNo": que.mobileNo, "userName": que.userName, "msg": que.message, "id":que.id});
      print('Send Result : $result');

    } on PlatformException catch (e) {
      print('Failed to Send Sms. Error: ${e.message}');
    }

  }
}




//      if(result == "SMS Sent"){
//        send = true;
//
////        SmsHistoryModel history = SmsHistoryModel(
////        mobileNo: que.mobileNo.toString(),
////        massage: que.message.toString(),
////        userName: que.userName.toString(),
////        send: true
////        );
////
////        //add to history table here. don't use wait
////        db.insertHistoryItem(history);
//
//      print('Send Result : $send');
//      }
