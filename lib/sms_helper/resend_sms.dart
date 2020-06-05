// import 'package:flutter/material.dart';
// import 'package:sql_db/db/model/sms_history_model.dart';
// import 'package:sql_db/db/utils/db_helper.dart';
// import 'package:sql_db/sms_helper/send_sms.dart';

// class SmsResend {
//   DatabaseHelper databaseHelper = DatabaseHelper();
//   SmsHistoryModel smsHistory;

// // resend sms
// // // Stream<List<SmsQueue>>
//   smsResend(BuildContext context,
//       {int id, String mobile, String massage}) async {
//     smsHistory.id;
// // Set true if sms send successfuly
//     bool send = await sendSms(massage: massage, mobile: mobile);

// // Update sms History if sms send successfuly in resend method
//     print('Send Sms: $send');
//     if (send) {
//       databaseHelper.updateHistory(smsHistory);

//       // updateHistory(
//       //     context: context,
//       //     id: id,
//       //     mobile: mobile,
//       //     send: send,
//       //     date: DateTime.now());
//     } else {
//       print('Can not Updated coz Send : send');
//     }
//   }
// }
