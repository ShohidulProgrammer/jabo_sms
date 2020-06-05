import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sql_db/db/model/sms_queue_model.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import 'package:sql_db/utilities/list_separator.dart';
import 'package:sql_db/widgets/snackbar.dart';
import '../widgets/sms_queue_list_item.dart';

class SmsQueueList extends StatefulWidget {
  @override
  _SmsQueueListState createState() => _SmsQueueListState();
}

class _SmsQueueListState extends State<SmsQueueList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSmsQueueList(context),
    );
  }

  Widget _buildSmsQueueList(BuildContext context) {
    DatabaseHelper db = DatabaseHelper.db;

    return FutureBuilder<List<SmsQueueModel>>(
      future: db.getAllQueues(),
      builder: (context, AsyncSnapshot<List<SmsQueueModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data.length,
            itemBuilder: (_, int index) {
              SmsQueueModel smsQueueItem = snapshot.data[index];
              return queueListItem(
                smsQueue: smsQueueItem,
                child: SmsQueueListItem(
                  smsQueue: smsQueueItem,
                  smsDao: db,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                klistSparatorDivider(),
          );
        } else if (snapshot.hasError) {
          return Text('There was an error');
        } else {
          // return Center(child: CircularProgressIndicator());
          return Text('No Value yet');
        }
      },
    );
  }

  // sms history list item
  Slidable queueListItem(
      {SmsQueueModel smsQueue, DatabaseHelper dao, Widget child}) {
    return Slidable(
      child: child,
      actionPane: SlidableBehindActionPane(),
      secondaryActions: <Widget>[
        //  delete List  item
        IconSlideAction(
            key: UniqueKey(),
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              dao.deleteMassageItem(
                  table: dao.queueTable, mobile: smsQueue.mobileNo);
              mySnackBar(context: context, msg: 'Sms Successfully Deleted!');
              setState(() {});
            }),
      ],
    );
  }
}
