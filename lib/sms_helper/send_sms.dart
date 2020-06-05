import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

// send sms to mobile device
Future<bool> sendSms({
  @required mobile,
  @required massage,
}) async {
  bool send = false;
  int faild = 1;
  try {
//  SimCardsProvider provider = new SimCardsProvider();
// SimCard card = await provider.getSimCards()[0];

    SmsSender sender = new SmsSender();
    SmsMessage message = SmsMessage(mobile, massage);

    message.onStateChanged.listen((state) async {
      if (state == SmsMessageState.Sent) {
        send = true;
        print("Sent = $send");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
        send = true;
      } else if ((state == SmsMessageState.Fail) && (faild <= 5)) {
        await sender.sendSms(message).catchError((onError) {
          print('\nSms Resend error:  $onError');
        });
        print("\nSMS is Fail ${faild++} times! error:   $state");
      }
    });

    await sender.sendSms(message);
    print('Send sms to: $mobile, successfully sended: $send');
  } catch (e) {
    print("\nsome error: $e");
  }
  return Future.delayed(Duration(seconds: 3), () => send);
}
