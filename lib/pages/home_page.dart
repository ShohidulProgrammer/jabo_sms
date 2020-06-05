import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ida Sms Home Page'),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Sms Queue'),
                onPressed: () => Navigator.pushNamed(context, 'sms_queue'),
              ),
              RaisedButton(
                child: Text('Sms History'),
                onPressed: () => Navigator.pushNamed(context, 'sms_history'),
              )
            ]),
      ),
    );
  }
}
