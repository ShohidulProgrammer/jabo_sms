import 'package:flutter/cupertino.dart';
import 'package:ideasms/db/model/sms_history_model.dart';
import 'package:ideasms/repository/repository.dart';
import 'dart:async';

class HistoryBloc with ChangeNotifier  {
  //Get instance of the Repository
  final _repository = Repository();

  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _historyController =
      StreamController<List<SmsHistoryModel>>.broadcast();

  get histories => _historyController.stream;

  HistoryBloc() {
    getHistories();
  }

  Future<List<SmsHistoryModel>> getHistories() async {
    await _repository.getAllHistories();
    notifyListeners();
    //sink is a way of adding data reactively to the stream
    //by registering a new event
//    _historyController.sink.add(await _repository.getAllHistories());
  }

//  getHistory({int id}) async {
//    //sink is a way of adding data reactively to the stream
//    //by registering a new event
//    _historyController.sink.add(await _repository.getHistoryItem(id));
//  }

  getMessages({@required String mobile}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _historyController.sink
        .add(await _repository.getAllMessageHistory(mobile: mobile));
  }

//  getMobiles() async {
//    //sink is a way of adding data reactively to the stream
//    //by registering a new event
//    _historyController.sink.add(await _repository.getAllMobileHistories());
//  }

  addHistory(SmsHistoryModel history) async {
    await _repository.saveHistoryItem(history);
    getHistories();
  }

  updateHistory(SmsHistoryModel history) async {
    await _repository.updateHistoryItem(history);
    getHistories();
  }

  delete({@required String table, @required int id}) async {
    _repository.deleteItem(table: table, id: id);
    getHistories();
  }

  deleteAll({@required String table}) async {
    _repository.deleteAll(table: table);
    getHistories();
  }

  deleteMassages({@required String table, @required String mobile}) async {
    _repository.deleteMassages(table: table, mobile: mobile);
    getHistories();
  }

//  isSend({@required SmsHistoryModel history}) async {
//    _repository.isSend(history: history);
//    getHistories();
//  }

  dispose() {
    _historyController.close();
  }
}
