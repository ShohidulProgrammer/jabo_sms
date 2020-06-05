import 'package:flutter/material.dart';
import 'package:ideasms/bloc/history_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../db/model/sms_history_model.dart';
import '../db/utils/db_helper.dart';
import '../utilities/list_separator.dart';
import '../widgets/sms_history_list_item.dart';

DatabaseHelper dbHelper = DatabaseHelper.db;

class HistoryList extends StatelessWidget {
  final String appTitle = 'SMS history';
//  Future<List<SmsHistoryModel>> _listFuture;
  final HistoryBloc historyBloc = HistoryBloc();
  final globalKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(appTitle),
        actions: <Widget>[
          // Delete All Data from History table
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              String title = 'Confirm deletion';
              String desc = 'Are you sure to delete all these messages?';
              myAlertDialog(
                context: context,
                title: title,
                desc: desc,
              );
            },
          ),
        ],
      ),
      body: Container(
        child: _buildSmsHistoryList(context),
      ),
    );
  }

  Widget _buildSmsHistoryList(BuildContext context) {
    final bloc = Provider.of<HistoryBloc>(context);
//    return StreamBuilder<List<SmsHistoryModel>>(
    return
      FutureBuilder<List<SmsHistoryModel>>(
//        future: historyBloc.histories,
        future: bloc.getHistories(),
        builder: (context, AsyncSnapshot<List<SmsHistoryModel>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          else if (snapshot.hasError) {
            debugPrint('Snap Shot Data: ${snapshot.data}');
            return Center(child: Text('There was an error'));
          } else if (snapshot.hasData) {
            return snapshot.data.length != 0
                ? ListView.separated(
                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (_, int index) {
                      SmsHistoryModel smsHistoryItem =
                          snapshot.data[index] ?? 0;
                      return historyListItem(
                        context: context,
                        smsHistory: smsHistoryItem,
                        child: SmsHistoryItemWidget(
                          smsHistory: smsHistoryItem,
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        kListSparatorDivider(),
                  )
                : Center(child: Text('No SMS'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

// sms history list item
  Widget historyListItem(
      {BuildContext context, SmsHistoryModel smsHistory, Widget child}) {
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
              historyBloc.deleteMassages(
                  table: dbHelper.historyTable, mobile: smsHistory.mobileNo);
//              dbHelper.deleteMassages(
//                  table: dbHelper.historyTable, mobile: smsHistory.mobileNo);
              showSnackbar(context, 'Massages are successfully deleted!');
//              setState(() {
//                refreshList();
//              });
            }),
      ],
    );
  }

////  @override
//  void initState() {
////    super.initState();
//    // notification handle on foreground state
//    getNotification();
//    // permission for showing notification on status bar for ios
//
//
//    // initial List load
////    _listFuture = dbHelper.getAllMobileHistories();
//  }

//  // rebuild any time when coming to this page
//  @override
//  void didChangeDependencies() {
//    refreshList();
//    print('didChangeDependencies was called');
//
////    super.didChangeDependencies();
//  }

//  refreshList() {
//    // reload
//    setState(() {
//      _listFuture = dbHelper.getAllMobileHistories();
//    });
////    showSnackbar(context, 'Successfully Refresh!');
//  }

  Future<void> myAlertDialog({
    BuildContext context,
    String title,
    String desc,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(desc),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                historyBloc.deleteAll(table: dbHelper.historyTable);
                showSnackbar(context, 'All Sms History Deleted successfully!');
//                refreshList();
//                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void showSnackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    globalKey.currentState.showSnackBar(snackBar);
  }
}
