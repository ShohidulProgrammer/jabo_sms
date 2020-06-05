import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/sms_history_model.dart';
import '../model/sms_queue_model.dart';
import 'package:intl/intl.dart';
import 'db_helper.dart';

class Dao {
  final dbHelper = DatabaseHelper.db;


  Future<int> saveQItem(SmsQueueModel que) async {
    final db = await dbHelper.database;
    //get the biggest id in the table
    var tableData =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM ${dbHelper.queueTable}");
    int id = tableData.first[dbHelper.colId];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into ${dbHelper.queueTable} (${dbHelper.colId}, ${dbHelper.colMobile}, ${dbHelper.colUser}, ${dbHelper.colMessage})"
        " VALUES (?,?,?,?)",
        [id, que.mobileNo, que.userName, que.message]);
    return raw;
  }

  Future<int> saveHistoryItem(SmsHistoryModel que) async {
    final db = await dbHelper.database;
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat dateFormat = DateFormat();
    String date = dateFormat.format(DateTime.now());

    //get the biggest id in the table
    var table = await db
        .rawQuery("SELECT MAX(id)+1 as id FROM ${dbHelper.historyTable}");
    int id = table.first[dbHelper.colId];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into ${dbHelper.historyTable} (${dbHelper.colId}, ${dbHelper.colMobile}, ${dbHelper.colUser}, ${dbHelper.colMessage}, ${dbHelper.colDate}, ${dbHelper.colSend})"
        " VALUES (?,?,?,?,?,?)",
        [id, que.mobileNo, que.userName, que.message, date, que.send]);
    return raw;
  }

  Future<int> updateQueueItem(SmsQueueModel que) async {
    final db = await dbHelper.database;
    var res = await db.update(dbHelper.queueTable, que.toMap(),
        where: "${dbHelper.colId} = ?", whereArgs: [que.id]);
    return res;
  }

  Future<int> updateHistoryItem(SmsHistoryModel history) async {
    final db = await dbHelper.database;
    var res = await db.update(dbHelper.historyTable, history.toMap(),
        where: "${dbHelper.colId} = ?", whereArgs: [history.id]);
    return res;
  }

  Future<SmsQueueModel> getQueueItem(int id) async {
    final db = await dbHelper.database;
    var res = await db.query(dbHelper.queueTable,
        where: "${dbHelper.colId} = ?", whereArgs: [id]);
    return res.isNotEmpty ? SmsQueueModel.fromMap(res.first) : null;
  }

  Future<SmsHistoryModel> getHistoryItem(int id) async {
    final db = await dbHelper.database;
    var res = await db.query(dbHelper.historyTable,
        where: "${dbHelper.colId} = ?", whereArgs: [id]);
    return res.isNotEmpty ? SmsHistoryModel.fromMap(res.first) : null;
  }

  Future<List<SmsQueueModel>> getAllMassageQueue({@required mobile}) async {
    final db = await dbHelper.database;

    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query(dbHelper.queueTable,
        where: "${dbHelper.colMobile} = ? ", whereArgs: [mobile]);

    List<SmsQueueModel> list =
        res.isNotEmpty ? res.map((c) => SmsQueueModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SmsHistoryModel>> getAllMessageHistory({@required mobile}) async {
    final db = await dbHelper.database;

    var res = await db.query(dbHelper.historyTable,
        where: "${dbHelper.colMobile} = ? ", whereArgs: [mobile]);

    List<SmsHistoryModel> list = res.isNotEmpty
        ? res.map((c) => SmsHistoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<SmsQueueModel>> getAllQueues() async {
    final db = await dbHelper.database;
    var res = await db.query(dbHelper.queueTable);
    List<SmsQueueModel> list =
        res.isNotEmpty ? res.map((c) => SmsQueueModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SmsHistoryModel>> getAllHistories() async {
    final db = await dbHelper.database;
    var res = await db.query(dbHelper.historyTable);
    List<SmsHistoryModel> list = res.isNotEmpty
        ? res.map((c) => SmsHistoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<SmsHistoryModel>> getAllMobileHistories() async {
    final db = await dbHelper.database;
    var res = await db.rawQuery(
        'SELECT * FROM ${dbHelper.historyTable} group by ${dbHelper.colMobile}');
    List<SmsHistoryModel> list = res.isNotEmpty
        ? res.map((c) => SmsHistoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<int> deleteMassages({String table, String mobile}) async {
    print('all messages deleted');
    final db = await dbHelper.database;
    return db.delete(table,
        where: "${dbHelper.colMobile} = ?", whereArgs: [mobile]);
  }

  Future<int> deleteItem({String table, int id}) async {
    final db = await dbHelper.database;
    return db.delete(table, where: "${dbHelper.colId} = ?", whereArgs: [id]);
  }

  Future deleteAll({String table}) async {
    final db = await dbHelper.database;
    db.rawDelete("Delete  from $table");
  }

  Future<int> isSend(SmsHistoryModel history) async {
    final db = await dbHelper.database;
    SmsHistoryModel send = SmsHistoryModel(
        id: history.id,
        mobileNo: history.mobileNo,
        userName: history.userName,
        message: history.message,
        // date: history.date,
        send: history.send);
    var res = await db.update(dbHelper.historyTable, send.toMap(),
        where: "${dbHelper.colId} = ?", whereArgs: [history.id]);
    return res;
  }
}
