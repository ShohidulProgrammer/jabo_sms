import 'package:flutter/services.dart';
import 'dart:async';

class SmsResult {
  static const String CHANNEL = "smsResultChannel";
  static const platform =  MethodChannel(CHANNEL);
  Future get sendData async => platform.setMethodCallHandler(result);


  Future<void> result(MethodCall call) async {
    // type inference will work here avoiding an explicit cast
//    final String utterance = call.arguments;
    switch(call.method) {
      case "getSmsResult":
        final String smsInfo = call.arguments;
//        processUtterance(utterance);
        print('Received Sms Result: $smsInfo');
    }
  }
}







//Future<void> didRecieveTranscript(MethodCall call) async {
//  // type inference will work here avoiding an explicit cast
//  final String utterance = call.arguments;
//  switch(call.method) {
//    case "didRecieveTranscript":
////        processUtterance(utterance);
//  }
//}
//
//
//result(){
//  // Flutter
//  final channelName = 'wingquest.stablekernel.io/speech';
//
//  final methodChannel = MethodChannel(channelName);
//  methodChannel.setMethodCallHandler(didRecieveTranscript);
//
//
//}