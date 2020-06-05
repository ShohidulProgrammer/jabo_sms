import 'package:flutter/material.dart';
import 'package:sql_db/db/model/sms_queue_model.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import '../http_helper/get_dart.dart';
import 'send_sms_from_gueue.dart';


DatabaseHelper db = DatabaseHelper.db;
SmsQueueModel smsQueue;
makeReadyToSendSms(BuildContext context) async {
  var smsQueueList;
  int i;

  try {
    smsQueueList = await getDataFromWeb();
  } catch (e) {
    print('\nnetwork error: $e');
  }

  // insert queue from web url
  try {
    for (i = 0; i < smsQueueList.length; i++) {
      await db.insertQueueItem(SmsQueueModel(
          id: smsQueueList[i]['id'],
          mobileNo: smsQueueList[i]['mobileNo'],
          userName: smsQueueList[i]['userName'],
          message: smsQueueList[i]['massage']));
    }
  } catch (e) {
    print('\nsmsQue insertion error: $e');
  }

  // send sms from queue table
  try {
    sendSmsFromQueue(context);
  } catch (e) {
    print('\nsms send error: $e');
  }

  print('\nafter send sms from que the last line');
}
