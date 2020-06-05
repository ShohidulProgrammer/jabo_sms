import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities/date_formatter.dart' as duration;

String getTime({@required String dateTime}) {
  var parsedDate = DateTime.parse(dateTime);
  final daytimeFormat = DateFormat.yMEd().add_jm().format(parsedDate);
  var daytimeArray = daytimeFormat.split(" ");
  String date = duration.formateDate(parsedDate);
  String time = '$date, ${daytimeArray[2]} ${daytimeArray[3]}';
  return time;
}
