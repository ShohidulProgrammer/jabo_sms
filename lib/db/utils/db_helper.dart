import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/sms_history_model.dart';
import '../model/sms_queue_model.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  DatabaseHelper._(); // Singleton DatabaseHelper
  static final DatabaseHelper db = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "SmsDB.db");
    print("\n\nDatabase Path: $path");
//    Database Path: /data/user/0/com.example.sql_db/app_flutter/SmsDB.db

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS
        $queueTable(
         $colId INTEGER PRIMARY KEY ,
          $colMobile TEXT,
          $colUser TEXT,
          $colMessage TEXT);
          ''');
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $historyTable(
            $colId INTEGER PRIMARY KEY ,
            $colMobile TEXT,
            $colUser TEXT,
            $colMessage TEXT,
             $colDate TEXT,
             $colSend BIT);
          ''');
    });
  }

  final String queueTable = 'sms_queue_table';
  final String historyTable = 'sms_history_table';
  final String colId = 'id';
  final String colMobile = 'mobileNo';
  final String colUser = 'userName';
  final String colMessage = 'message';
  final String colDate = 'date';
  final String colSend = 'send';

  insertQueueItem(SmsQueueModel que) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $queueTable");
    int id = table.first[colId];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into $queueTable ($colId, $colMobile, $colUser, $colMessage)"
        " VALUES (?,?,?,?)",
        [id, que.mobileNo, que.userName, que.message]);
    return raw;
  }

  insertHistoryItem(SmsHistoryModel que) async {
    final db = await database;
    debugPrint('Inserting no: ' + que.mobileNo);
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat dateFormat = DateFormat();
    String date = dateFormat.format(DateTime.now());

    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $historyTable");
    int id = table.first[colId];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into $historyTable ($colId, $colMobile, $colUser, $colMessage, $colDate, $colSend)"
        " VALUES (?,?,?,?,?,?)",
        [id, que.mobileNo, que.userName, que.message, date, que.send]);
    debugPrint('Inserted no: ' + que.mobileNo);
    return raw;
  }

  updateQueueItem(SmsQueueModel que) async {
    final db = await database;
    var res = await db.update(queueTable, que.toMap(),
        where: "$colId = ?", whereArgs: [que.id]);
    return res;
  }

  updateHistoryItem(SmsHistoryModel history) async {
    final db = await database;
    var res = await db.update(historyTable, history.toMap(),
        where: "$colId = ?", whereArgs: [history.id]);
    return res;
  }

  getQueueItem(int id) async {
    final db = await database;
    var res = await db.query(queueTable, where: "$colId = ?", whereArgs: [id]);
    return res.isNotEmpty ? SmsQueueModel.fromMap(res.first) : null;
  }

  getHistoryItem(int id) async {
    final db = await database;
    var res =
        await db.query(historyTable, where: "$colId = ?", whereArgs: [id]);
    return res.isNotEmpty ? SmsHistoryModel.fromMap(res.first) : null;
  }

  Future<List<SmsQueueModel>> getAllMassageQueue({@required mobile}) async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db
        .query(queueTable, where: "$colMobile = ? ", whereArgs: [mobile]);

    List<SmsQueueModel> list =
        res.isNotEmpty ? res.map((c) => SmsQueueModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SmsHistoryModel>> getAllMassageHistory({@required mobile}) async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db
        .query(historyTable, where: "$colMobile = ? ", whereArgs: [mobile]);

    List<SmsHistoryModel> list = res.isNotEmpty
        ? res.map((c) => SmsHistoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<SmsQueueModel>> getAllQueues() async {
    final db = await database;
    var res = await db.query(queueTable);
    List<SmsQueueModel> list =
        res.isNotEmpty ? res.map((c) => SmsQueueModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SmsHistoryModel>> getAllHistories() async {
    final db = await database;
    var res = await db.query(historyTable);
    List<SmsHistoryModel> list = res.isNotEmpty
        ? res.map((c) => SmsHistoryModel.fromMap(c)).toList()
        : [];
    return list;
  }

  deleteMassageItem({String table, String mobile}) async {
    final db = await database;
    return db.delete(table, where: "$colMobile = ?", whereArgs: [mobile]);
  }

  deleteItem({String table, int id}) async {
    final db = await database;
    return db.delete(table, where: "$colId = ?", whereArgs: [id]);
  }

  deleteAll({String table}) async {
    final db = await database;
    db.rawDelete("Delete  from $table");
  }

  isSend(SmsHistoryModel history) async {
    final db = await database;
    SmsHistoryModel send = SmsHistoryModel(
        id: history.id,
        mobileNo: history.mobileNo,
        userName: history.userName,
        message: history.message,
        // date: history.date,
        send: history.send);
    var res = await db.update(historyTable, send.toMap(),
        where: "$colId = ?", whereArgs: [history.id]);
    return res;
  }
}
