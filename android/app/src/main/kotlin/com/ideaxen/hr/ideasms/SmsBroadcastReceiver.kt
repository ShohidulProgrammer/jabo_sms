package com.ideaxen.hr.ideasms

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.app.Activity
import android.telephony.SmsManager
import com.ideaxen.hr.ideasms.MainActivity.Companion.RECEIVED_SMS_INFO
import java.text.SimpleDateFormat
import java.util.*


class SmsBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val sdf = SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
        val smsReceiveTime = sdf.format(Date())
        val dbHelper = DBHelper(context)

        val action = intent.action
        var sendResult = false

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


            if (smsInfo!!.isNotEmpty()) {
                println("Sms Send Info: ID: ${smsInfo[0]} Mobile: ${smsInfo[1]} User: ${smsInfo[2]}, Previous Send Result: ${smsInfo[4]}  New Send Result: $sendResult")
                try {
                    // Set SMS send result
                    var send = 0
                    var sendR = "0"
                    // sendResult == true set send = 1
                    if (sendResult) {
                        send = 1
                        sendR = "1"
                    }


                    var smsResult = arrayOfNulls<String>(5)
                    smsResult = smsInfo.copyOfRange(0, 4).plus(smsReceiveTime).plus(sendR)
                    println("Complete SMS: ${smsResult.contentToString()}")


                    // check sms previous send result
                    if (smsInfo[4] == "-1") {
                        println("\ninsert ID: ${smsInfo[0]} Old send result: ${smsInfo[4]}")
                        // insert Data in history table
                        dbHelper.insertData(DBHelper.SMS_HISTORY_TABLE, smsInfo[0], smsInfo[1], smsInfo[2], smsInfo[3], smsReceiveTime, send)
                    } else {
                        println("\nUpdate ID: ${smsInfo[0]} Old send result: ${smsInfo[4]}")
                        // Update sms info in history table
                        dbHelper.update(DBHelper.SMS_HISTORY_TABLE, smsInfo[0], smsInfo[1], smsInfo[2], smsInfo[3], smsReceiveTime, send)
                    }

                } catch (e: Exception) {
                    println("DB Inserting error: $e")
                }

            }
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
}