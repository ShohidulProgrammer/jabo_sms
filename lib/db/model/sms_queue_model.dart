import 'dart:convert';

SmsQueueModel queueFromJson(String str) {
  final jsonData = json.decode(str);
  return SmsQueueModel.fromMap(jsonData);
}

String queueToJson(SmsQueueModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class SmsQueueModel {
  int id;
  String mobileNo;
  String userName;
  String message;

  SmsQueueModel({this.id, this.mobileNo, this.message, this.userName});

  factory SmsQueueModel.fromMap(Map<String, dynamic> json) => new SmsQueueModel(
        id: json["id"],
        mobileNo: json['mobileNo'],
        userName: json['userName'],
        message: json['message'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'mobileNo': mobileNo,
        'userName': userName,
        'message': message,
      };
}
