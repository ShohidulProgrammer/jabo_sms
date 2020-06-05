import 'package:flutter/material.dart';
import 'package:ideasms/db/model/sms_history_model.dart';
import 'package:ideasms/db/model/sms_queue_model.dart';
import 'package:ideasms/db/utils/dao.dart';

class Repository {
  final dao = Dao();

  Future saveQItem(SmsQueueModel que) => dao.saveQItem(que);

  Future saveHistoryItem(SmsHistoryModel history) =>
      dao.saveHistoryItem(history);

  Future updateQueueItem(SmsQueueModel que) => dao.updateQueueItem(que);

  Future updateHistoryItem(SmsHistoryModel history) =>
      dao.updateHistoryItem(history);

  Future getQueueItem(int id) => dao.getQueueItem(id);

  Future getHistoryItem(int id) => dao.getHistoryItem(id);

  Future getAllMassageQueue({@required String mobile}) =>
      dao.getAllMassageQueue(mobile: mobile);

  Future getAllMessageHistory({@required String mobile}) =>
      dao.getAllMessageHistory(mobile: mobile);

  Future getAllQueues() => dao.getAllQueues();

  Future<List<SmsHistoryModel>> getAllHistories() => dao.getAllHistories();

  Future getAllMobileHistories() => dao.getAllMobileHistories();

  Future deleteMassages({@required String table, @required String mobile}) =>
      dao.deleteMassages(table: table, mobile: mobile);

  Future deleteItem({@required String table, @required int id}) =>
      dao.deleteItem(table: table, id: id);

  Future deleteAll({@required String table}) => dao.deleteAll(table: table);

  Future isSend({@required SmsHistoryModel history}) => dao.isSend(history);
}
