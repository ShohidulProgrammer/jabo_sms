import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bloc/history_bloc.dart';
import 'router/router.dart';
import 'utilities/get_notification.dart';
import 'widgets/sms_history_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getNotification();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HistoryBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sms Sender',
          theme: new ThemeData(
              scaffoldBackgroundColor: Color(0xfffafaff),
              buttonColor: Colors.grey),
          routes: routes,
        ));
  }
}
