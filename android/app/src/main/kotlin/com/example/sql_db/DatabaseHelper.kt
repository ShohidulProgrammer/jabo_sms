package com.example.sql_db;

import android.content.Context
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase

/**
 * Let's start by creating our database CRUD helper class
 * based on the SQLiteHelper.
 *
 */


class DatabaseHelper(context: Context) :
        SQLiteOpenHelper(context, DATABASE_NAME, null, 1) {
    /**
     * Our onCreate() method.
     * Called when the database is created for the first time. This is
     * where the creation of tables and the initial population of the tables
     * should happen.
     */

    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE IF NOT EXISTS $SMS_HISTORY_TABLE (ID INTEGER PRIMARY KEY " +
                "AUTOINCREMENT,$MOBILE TEXT,$USER TEXT,$MESSAGE TEXT $SENDRESULT BIT)")
    }

    /**
     * Let's create Our onUpgrade method
     * Called when the database needs to be upgraded. The implementation should
     * use this method to drop tables, add tables, or do anything else it needs
     * to upgrade to the new schema version.
     */
    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS " + SMS_HISTORY_TABLE)
        onCreate(db)
    }

    /**
     * Let's create our insertData() method.
     * It Will insert data to SQLIte database.
     */
    fun insertData(mobile: String, user: String, msg: String, date: String, send: Int) {
//        val db = this.writableDatabase
        val db = SQLiteDatabase.openDatabase("/data/user/0/com.example.sql_db/app_flutter/SmsDB.db", null, 0)
        val contentValues = ContentValues()
        contentValues.put(MOBILE, mobile)
        contentValues.put(USER, user)
        contentValues.put(MESSAGE, msg)
        contentValues.put(DATE, date)
        contentValues.put(SENDRESULT, send)
        db.insert(SMS_HISTORY_TABLE, null, contentValues)
        println("Inserted to History table Mobile: $mobile, User: $user, Message: $msg Date: $date Send Result: $send")
    }

    /**
     * Let's create  a method to update a row with new field values.
     */
    fun updateData(id: String, mobile: String, user: String, msg: String):
            Boolean {
        val db = this.writableDatabase
        val contentValues = ContentValues()
        contentValues.put(ID, id)
        contentValues.put(MOBILE, mobile)
        contentValues.put(USER, user)
        contentValues.put(MESSAGE, msg)
        db.update(SMS_HISTORY_TABLE, contentValues, "ID = ?", arrayOf(id))
        return true
    }

    /**
     * Let's create a function to delete a given row based on the id.
     */
    fun deleteData(id: String): Int {
        val db = this.writableDatabase
        return db.delete(SMS_HISTORY_TABLE, "ID = ?", arrayOf(id))
    }

    /**
     * The below getter property will return a Cursor containing our dataset.
     */
    val allData: Cursor
        get() {
            val db = this.writableDatabase
            val res = db.rawQuery("SELECT * FROM " + SMS_HISTORY_TABLE, null)
            return res
        }

    /**
     * Let's create a companion object to hold our static fields.
     * A Companion object is an object that is common to all instances of a given
     * class.
     */
    companion object {
        const val DATABASE_NAME = "SmsDB.db"
        const val SMS_HISTORY_TABLE = "sms_history_table"
        const val ID = "id"
        const val MOBILE = "mobileNo"
        const val USER = "userName"
        const val MESSAGE = "message"
        const val DATE = "date"
        const val SENDRESULT = "send"
    }
}
//end