import 'package:flutter/material.dart';
import 'package:sql_db/pages/sms_history_home_page.dart';
import '../pages/home_page.dart';
import '../pages/sms_queue_home_page.dart';

final routes = {
  '/': (BuildContext context) => HomePage(),
  'sms_queue': (BuildContext context) => SmsQueueHomePage(),
  'sms_history': (BuildContext context) => SmsHistoryHomePage(),

  // 'sms_history_details': (BuildContext context) => SmsHistoryDetails(smsItem: null,),
  // '/send_sms': (BuildContext context) => SendSms(),
  // '/join': (BuildContext context) => PageJoinQuery(),
  // '/upsert': (BuildContext context) => UpsertPage(),
};
