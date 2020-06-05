import 'package:flutter/material.dart';
import 'package:ideasms/db/utils/db_helper.dart';
import '../utilities/get_time.dart';
import '../pages/sms_history_detals.dart';
import '../utilities/date_formatter.dart' as duration;
import 'history_details.dart';

class SmsHistoryItemWidget extends StatelessWidget {
  final smsHistory;

  SmsHistoryItemWidget({Key key, @required this.smsHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var parsedDate = DateTime.parse(smsHistory.date);
    String date = duration.formateDate(parsedDate);
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryDetails(
                      mobile: smsHistory.mobileNo,
                    ))),
        child: ListTile(
          leading: smsHistory.send
              ? Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : Icon(
                  Icons.sms_failed,
                  color: Colors.red,
                ),
          title: Text(smsHistory.mobileNo),
          subtitle: Text(smsHistory.userName ?? ''),
          trailing: Text(
            getTime(dateTime: smsHistory.date),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ));
  }
}
