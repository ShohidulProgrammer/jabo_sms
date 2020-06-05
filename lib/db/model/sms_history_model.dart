import 'dart:convert';

SmsHistoryModel historyFromJson(String str) {
  final jsonData = json.decode(str);
  return SmsHistoryModel.fromMap(jsonData);
}

String historyToJson(SmsHistoryModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class SmsHistoryModel {
  int id;
  String mobileNo;
  String userName;
  String message;
  String date;
  bool send;

  SmsHistoryModel(
      {this.id,
      this.mobileNo,
      this.message,
      this.userName,
      this.date,
      this.send});

  factory SmsHistoryModel.fromMap(Map<String, dynamic> json) =>
      new SmsHistoryModel(
        id: json["id"],
        mobileNo: json['mobileNo'],
        userName: json['userName'],
        message: json['message'],
        date: json['date'],
        send: json['send'] == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'mobileNo': mobileNo,
        'userName': userName,
        'message': message,
        'date': date,
        'send': send
      };
}
