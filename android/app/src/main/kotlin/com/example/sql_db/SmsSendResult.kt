package com.example.sql_db
//
//import android.annotation.SuppressLint
//import android.app.Application
//import android.content.Intent
//
//
//@SuppressLint("Registered")
//class SmsSendResult : Application() {

//    override fun onCreate() {
//        super.onCreate(savedInstanceState)
//        val intent: Intent = getIntent()
//        val myStrings: Array<String?>? = intent.getStringArrayExtra("strings")
//    }
//
//    override fun startActivity(intent: Intent?) {
//        super.startActivity(intent)
////        val action = intent!!.action
////        if (action == SmsBroadcastReceiver.ACTION_RESULT_SEND_SMS_INFO) {
////            val smsInfo = intent.getStringArrayExtra(SmsBroadcastReceiver.RESULT_SEND_SMS_INFO)
////            println("Sms Send Listen Info: ID: ${smsInfo[0]} Mobile: ${smsInfo[1]} Message: ${smsInfo[2]}  Send Result: ${smsInfo[3]}")
////        }
//
//        val smsInfo = intent?.getStringArrayExtra(SmsBroadcastReceiver.RESULT_SEND_SMS_INFO)
//        println("Sms Send Listen Info: ID: ${smsInfo?.get(0)} Mobile: ${smsInfo?.get(1)} Message: ${smsInfo?.get(2)}  Send Result: ${smsInfo?.get(3)}")
//
//
//    }

//    fun  newIntent( context: Context, sms: Array<String?>): Intent {
//        val smsIntent =  Intent(SmsBroadcastReceiver.ACTION_RESULT_SEND_SMS_INFO)
//        smsIntent.putExtra(SmsBroadcastReceiver.RESULT_SEND_SMS_INFO, sms)
//        return smsIntent
//    }


//}

//class SmsSendResultPass {
//    var id = -1
//    private  var mobile = ""
//    private var msg = ""
//     var result = false
//
//    SmsSendResultPass(id: Int, mobile: String, msg: String, result: Boolean){
//        this.id = id
//    }
//
////    internal fun ObjectPassDemo(id: Int, mobile: String, msg: String, result: Boolean) {
////        id = id
////    }
//
//    companion object {
//
//    }
//
//}


//class SmsSendResultReceived internal constructor(private var id: Int, private var mobile: String, private var msg: String, private var result: Boolean) {
//
//
//    internal fun setSms(sms:SmsSendResultReceived){
//        sms.id = id
//        sms.mobile = mobile
//        sms.msg = msg
//        sms.result = result
//
//        println("Sms Send Info: ID: ${sms.id} Mobile: ${sms.mobile} Message: ${sms.msg}  Send Result: ${sms.result}")
//    }



//    // return true if o is equal to the invoking
//    // object notice an object is passed as an
//    // argument to method
//    internal fun equalTo(o: SmsSendResultReceived): Boolean {
//        return o.id == id && o.mobile == mobile
//    }

//}
