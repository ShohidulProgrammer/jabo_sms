import 'package:flutter/material.dart';
import 'package:sql_db/pages/sms_queue_details.dart';

class SmsQueueListItem extends StatelessWidget {
  final smsQueue;
  final smsDao;
  SmsQueueListItem({@required this.smsQueue, @required this.smsDao});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QueueSmsDetails(
                      smsQueItem: smsQueue,
                    ))),
        child: ListTile(
          title: Text(smsQueue.mobileNo),
          subtitle: Text(smsQueue.userName ?? ''),
        ));
  }
}
