import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:sql_db/db/model/sms_queue_model.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import '../sms_helper/my_sms_sender.dart';


DatabaseHelper dbHelper = DatabaseHelper.db;
MySmsSender sendSms = MySmsSender();

sendSmsFromQueue(BuildContext context) async {
  try {
    final List<SmsQueueModel> smsQueues = await dbHelper.getAllQueues(); // get data from queue

    // send sms each mobile no
    smsQueues.forEach((que){
      MySmsSender.sendSms(que: que);
    });
  } catch (e) {
    print('\nqueue data read error: $e');
  }
}
