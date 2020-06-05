package com.example.sql_db

import android.Manifest.*
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.telephony.SmsManager
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter


class MainActivity : FlutterActivity() {

    private val smsBroadcastReceiver = SmsBroadcastReceiver()

    // private MethodChannel.Result callResult;
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        this.registerReceiver(smsBroadcastReceiver, IntentFilter(ACTION_SMS_SENT))

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if ((checkSelfPermission(
                            permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED)) {

                // Should we show an explanation?
                if (shouldShowRequestPermissionRationale(
                                permission.SEND_SMS)) {
                    println("Request for permission")


                    // Show an explanation to the user *asynchronously* -- don't block
                    // this thread waiting for the user's response! After the user
                    // sees the explanation, try again to request the permission.
                } else {

                    // No explanation needed, we can request the permission.

                    requestPermissions(
                            arrayOf(permission.SEND_SMS),
                            0)

                    // MY_PERMISSIONS_REQUEST_SEND_SMS is an
                    // app-defined int constant. The callback method gets the
                    // result of the request.
                }
            }
        }

        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val mobile = call.argument<String>("mobileNo")
                val user = call.argument<String>("userName")
                val msg = call.argument<String>("msg")
                var id = call.argument<Int>("id")
                if (id == null) id = 0
                sendSMS(id, mobile,user, msg, result)
            } else {
                result.notImplemented()
            }
        }
    }


    override fun onDestroy() {
        this.unregisterReceiver(smsBroadcastReceiver)
        super.onDestroy()
    }


    //    send sms
    private fun sendSMS(id: Int, phoneNo: String?,user: String?, msg: String?, result: MethodChannel.Result) {
        try {
            println("main method send sms ID: $id")

            val sms = arrayOfNulls<String>(4)
            sms[0] = "$id"
            sms[1] = "$phoneNo"
            sms[2] = "$user"
            sms[3] = "$msg"
            val iSent = Intent(ACTION_SMS_SENT)

//            iSent.putExtra(RECEIVED_SMS_SENT, id)
            iSent.putExtra(RECEIVED_SMS_INFO, sms)

            val iDel = Intent(ACTION_SMS_DELIVERED)
            iDel.putExtra(RECEIVED_SMS_DELIVERED, id)


            // get the default instance of SmsManager
            val smsManager = SmsManager.getDefault()
//requestCode:int
            val piSent = PendingIntent.getBroadcast(this, id, iSent, 0)
            val piDel = PendingIntent.getBroadcast(this, id, iDel, 0)

            // send a text based SMS
            smsManager.sendTextMessage(phoneNo, null, msg, piSent, piDel)

//            val smsInfoIntent =

//    result.success("SMS Sent")

//    val parts = smsManager.divideMessage(msg)
//    iSent.putExtra("phoneNo",phoneNo)
//    startActivity(iSent)
//    if (parts.size == 1) {
//       val massage = parts[0]
//        smsManager.sendTextMessage(phoneNo, null, massage, piSent, piDel)
////    } else {
////        val sentPis = ArrayList<PendingIntent>()
////        val delPis = ArrayList<PendingIntent>()
////
////        val ct = parts.size
////        for (i in 0 until ct) {
////            sentPis.add(i, piSent)
////            delPis.add(i, piDel)
////        }
//
////        smsManager.sendMultipartTextMessage(phoneNo, null, parts, sentPis, delPis)
////        stopSelf(this.intent)
//        stopService(intent)
//    }


        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "Please! try again")
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<String>,
            grantResults: IntArray
    ) {
        when (requestCode) {
            0 -> {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    println("sms sending permission was granted")

                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.
                } else {
                    println("sms sending permission denied")
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return
            }
        } // other 'case' lines to check for other
        // permissions this app might request.
    }

    companion object {
        private const val CHANNEL = "smsChannel"
        const val ACTION_SMS_SENT = "com.ideaxen.sms360.SMS_SENT"
        const val ACTION_SMS_DELIVERED = "com.ideaxen.sms360.SMS_DELIVERED"
        //        const val RECEIVED_SMS_SENT = "com.ideaxen.sms360.RECEIVED_SMS_SENT"
        const val RECEIVED_SMS_DELIVERED = "com.ideaxen.sms360.RECEIVED_SMS_DELIVERED"
        const val RECEIVED_SMS_INFO = "com.ideaxen.sms360.RECEIVED_SMS_INFO"
        const val ACTION_RESULT_SEND_SMS_INFO = "com.ideaxen.sms360.ACTION_RESULT_SEND_SMS_INFO"
        const val RESULT_SEND_SMS_INFO = "com.ideaxen.sms360.RESULT_SEND_SMS_INFO"
        //    const val MY_PERMISSIONS_REQUEST_SEND_SMS = 9

//        val sms = arrayOf<String>()

    }

}
