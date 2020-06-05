import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sql_db/db/model/sms_history_model.dart';
import 'package:sql_db/db/utils/db_helper.dart';
import 'package:sql_db/utilities/list_separator.dart';
import 'package:sql_db/widgets/sms_history_list_item.dart';
import 'package:sql_db/widgets/snackbar.dart';

class SmsHistoryList extends StatefulWidget {
  @override
  _SmsHistoryListState createState() => _SmsHistoryListState();
}

class _SmsHistoryListState extends State<SmsHistoryList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildSmsHistoryList(context),
    );
  }

  Widget _buildSmsHistoryList(BuildContext context) {
    DatabaseHelper db = DatabaseHelper.db;

    return FutureBuilder<List<SmsHistoryModel>>(
        future: db.getAllHistories(),
        builder: (context, AsyncSnapshot<List<SmsHistoryModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (_, int index) {
                SmsHistoryModel smsHistoryItem = snapshot.data[index];
                return queueListItem(
                  smsHistory: smsHistoryItem,
                  child: SmsHistoryListItem(
                    smsHistory: smsHistoryItem,
                    smsDao: db,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  klistSparatorDivider(),
            );
          } else if (snapshot.hasError) {
            debugPrint('Snap Shot Data: ${snapshot.data}');
            return Center(child: Text('There was an error'));
          } else {
            // return Center(child: CircularProgressIndicator());
            return Center(child: Text('No Value yet'));
          }
        });
  }

// sms history list item
  Widget queueListItem(
      {SmsHistoryModel smsHistory, DatabaseHelper dao, Widget child}) {
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
              dao.deleteItem(table: dao.historyTable, id: smsHistory.id);
              mySnackBar(context: context, msg: 'Sms Successfully Deleted!');
              setState(() {});
            }),
      ],
    );
  }
}
