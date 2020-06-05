package com.example.sql_db

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsManager
import com.example.sql_db.MainActivity.Companion.RECEIVED_SMS_INFO
import java.text.SimpleDateFormat
import java.time.LocalDateTime
import java.util.*

class SmsBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val sdf = SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
        val smsReceiveTime = sdf.format(Date())
        System.out.println(" C DATE is  " + smsReceiveTime)

        val dbHelper = DatabaseHelper(context)

        val action = intent.action
        var sendResult = false

//        val sentId = intent.getIntExtra(MainActivity.RECEIVED_SMS_SENT, -1)
//        val deliveredId = intent.getIntExtra(MainActivity.RECEIVED_SMS_DELIVERED,-1)


        if (action == MainActivity.ACTION_SMS_SENT) {
            val smsInfo = intent.getStringArrayExtra(RECEIVED_SMS_INFO)

            when (resultCode) {
                Activity.RESULT_OK -> {
                    println("SMS is sent")
                    sendResult = true
                }
                SmsManager.RESULT_ERROR_GENERIC_FAILURE -> {
                    println("Generic failure")
                }


                SmsManager.RESULT_ERROR_NO_SERVICE -> {
                    println("No service")
                }

                SmsManager.RESULT_ERROR_NULL_PDU -> {
                    println("Null PDU")
                }

                SmsManager.RESULT_ERROR_RADIO_OFF -> {
                    println("Radio off")
                }
            }

//
//            try {
            if (smsInfo!!.isNotEmpty()) {
                println("Sms Send Info: ID: ${smsInfo[0]} Mobile: ${smsInfo[1]} User: ${smsInfo[2]}, Message: ${smsInfo[3]}  Send Result: $sendResult")
                try {
                    var send = 0

                    if (sendResult) {
                        send = 1
                    }
                    dbHelper.insertData(smsInfo[1], smsInfo[2], smsInfo[3], smsReceiveTime, send)
                    println("insert table call for ID: ${smsInfo[0]}")
                } catch (e: Exception) {
                    println("DB Inserting error: $e")
                }


//                    smsInfo[3] = "$sendResult"
//                    var id = smsInfo[0].toInt()
//                    intent.putExtra("RESULT_SEND_SMS_INFO", smsInfo);

//                    val sms = SmsSendResultReceived(id, smsInfo[1], smsInfo[1], sendResult)
//                    sms.setSms(sms)
//
//                    println("Broadcast Sms Result Received")
            }
//            } catch (e: IOException) {
//                // handler
//                println("Error: $e")
//            } finally {
//                // optional finally block
//            }


        }

//        else if ((action == MainActivity.ACTION_SMS_DELIVERED ) &&( deliveredId != -1)) {
//            when (resultCode) {
//                Activity.RESULT_OK -> {
//                    println("SMS delivered")
//                    println("Delivered ID: $deliveredId")
//                }
//
//                Activity.RESULT_CANCELED -> {
//                    println("SMS not delivered")
//
//                }
//            }
//        }
    }

//
//    companion object {
//        //        const val sendResult = false
////        const val ACTION_RESULT_SEND_SMS_INFO = "com.ideaxen.sms360.ACTION_RESULT_SEND_SMS_INFO"
////        const val RESULT_SEND_SMS_INFO = "com.ideaxen.sms360.RESULT_SEND_SMS_INFO"
//    }

}
