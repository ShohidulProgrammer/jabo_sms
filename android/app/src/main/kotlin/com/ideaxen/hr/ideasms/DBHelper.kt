package com.ideaxen.hr.ideasms

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.SQLException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import java.io.IOException

/**
 * Let's start by creating our database CRUD helper class
 * based on the SQLiteHelper.
 *
 */
class DBHelper(private val context: Context) :
        SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    private var db: SQLiteDatabase? = null

    val isOpen: Boolean
        get() = if (db != null) db!!.isOpen else false

    init {

        if (db != null && db!!.isOpen)
            close()

        try {
            createDataBase()
            openDataBase()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    @Throws(IOException::class)
    fun createDataBase() {
        val dbExist = checkDataBase()

        if (dbExist) {
            // System.out.println("Database Exist");
        } else {
            this.readableDatabase

            try {
//                copyDatabase()
            } catch (e: IOException) {
                throw Error("Error copying database")
            }

        }
    }

//
//    @Throws(IOException::class)
//    private fun copyDatabase() {
//        val input = context.assets.open(DATABASE_NAME)
//        val outputFileName = DB_PATH + DATABASE_NAME
//        val output = FileOutputStream(outputFileName)
//
//        val buffer = ByteArray(1024)
//        var length: Int
//        while ((length = input.read(buffer)) > 0) {
//            output.write(buffer, 0, length)
//        }
//
//        // Close the streams
//        output.flush()
//        output.close()
//        input.close()
//        // System.out.println(DB_NAME + "Database Copied !");
//    }


    /**
     * Our onCreate() method.
     * Called when the database is created for the first time. This is
     * where the creation of tables and the initial population of the tables
     * should happen.
     */
    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("CREATE TABLE IF NOT EXISTS $SMS_HISTORY_TABLE ($ID INTEGER PRIMARY KEY " +
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


    @Throws(SQLException::class)
    fun openDataBase() {
        // Open the database
        val myDBPath = DB_PATH + DATABASE_NAME
        db = SQLiteDatabase.openDatabase(myDBPath, null, SQLiteDatabase.OPEN_READWRITE)

    }

    @Synchronized
    override fun close() {
        if (db != null)
            db!!.close()
        super.close()
    }

    private fun checkDataBase(): Boolean {
        var checkDB: SQLiteDatabase? = null
        try {
            val myDBPath = DB_PATH + DATABASE_NAME
            checkDB = SQLiteDatabase.openDatabase(myDBPath, null,
                    SQLiteDatabase.OPEN_READWRITE)
        } catch (e: Exception) {
        }

        checkDB?.close()

//        return if (checkDB != null) true else false
        return checkDB != null

    }

    fun execCursorQuery(sql: String): Cursor? {
        var cursor: Cursor? = null
        try {
            cursor = db!!.rawQuery(sql, null)
        } catch (e: Exception) {
            Log.e("Err", e.message);
        }

        return cursor
    }

    fun execNonQuery(sql: String) {
        try {
            db!!.execSQL(sql)
        } catch (e: Exception) {
            Log.e("Err", e.message);
        } finally {
            close();
        }
    }


    fun insertData(table: String = SMS_HISTORY_TABLE, id: String, mobile: String, user: String, msg: String, date: String, send: Int) {
        println("ID: $id Date: $date")
        val values = ContentValues()
        values.put(MOBILE, mobile)
        values.put(USER, user)
        values.put(MESSAGE, msg)
        values.put(DATE, date)
        values.put(SENDRESULT, send)
        db!!.insert(table, null, values)
//        println("Successfully Inserted to History table Mobile: $mobile, User: $user, Message: $msg Date: $date Send Result: $send")

        db!!.delete(SMS_QUEUE_TABLE, "$ID = ?", arrayOf(id))
//        println("Que successfully deleted!")
        db!!.close()
    }


    fun update(table: String = SMS_HISTORY_TABLE, id: String, mobile: String, user: String, msg: String, date: String, send: Int) {
        val where: String
//        db = this.writableDatabase
        val values = ContentValues()
        values.put(ID, id)
        values.put(MOBILE, mobile)
        values.put(USER, user)
        values.put(MESSAGE, msg)
        values.put(DATE, date)
        values.put(SENDRESULT, send)
        if (id != null) {
            where = "$ID=$id"
        } else {
            where = "$ID = (SELECT MAX($ID) FROM $table)"
        }
        db!!.update(table, values, "$ID = ?", arrayOf(id.toString()))
        db!!.close()
    }

    fun fetchItem(table: String = SMS_HISTORY_TABLE, id: String): Cursor {
        db = this.writableDatabase
        val cursor = db!!.query(table, arrayOf(ID, MOBILE, USER, MESSAGE, DATE, SENDRESULT),
                "$ID=$id", null, null, null, "$DATE DESC")
        cursor.moveToFirst()
        db!!.close()
        return cursor
    }


//    var args = arrayOf("first string", "second@string.com")
//    var cursor = db.query("TABLE_NAME", null, "name=? AND email=?", args, null)

    fun fetchMobileMessages(mobile: String): Cursor {
        db = this.writableDatabase
        val messagesInfo = db!!.query(SMS_HISTORY_TABLE, arrayOf(ID, MOBILE, USER, MESSAGE, DATE, SENDRESULT),
                "$MOBILE=$mobile", null, null, null, "$DATE DESC")
        messagesInfo.moveToFirst()
        db!!.close()
        return messagesInfo
    }

    /**
     * The below getter property will return a Cursor containing our data set.
     */
    val getAllData: Cursor
        get() {
            db = this.writableDatabase
            val tableData = db!!.rawQuery("SELECT * FROM " + SMS_HISTORY_TABLE, null)
            db!!.close()
            return tableData
        }


    /**
     * Let's create a function to delete a given row based on the id.
     */
    fun deleteItem(table: String = SMS_HISTORY_TABLE, id: String) {
        if (table == SMS_QUEUE_TABLE) {
            val db = SQLiteDatabase.openDatabase("/data/user/0/com.example.idea_sms/app_flutter/IdeaSmsDB.db", null, 0)
        } else {
            db = this.writableDatabase
        }
        db!!.delete(table, "$ID = ?", arrayOf(id))
        db!!.close()
    }

    fun deleteLastItem(table: String = SMS_HISTORY_TABLE) {
        db = this.writableDatabase
        db!!.delete(table, "$ID = (SELECT MAX($ID) FROM $table)", null)
        db!!.close()
    }

    fun deleteMobileMassages(table: String = SMS_HISTORY_TABLE, mobile: String) {
        db = this.writableDatabase
        db!!.delete(table, "$MOBILE= ?", arrayOf(mobile));
    }


    fun deleteAll(table: String = SMS_HISTORY_TABLE) {
        db = this.writableDatabase
        db!!.delete(table, null, null)
        db!!.close()
    }


    /**
     * Let's create a companion object to hold our static fields.
     * A Companion object is an object that is common to all instances of a given
     * class.
     */
    companion object {
        private val DATABASE_VERSION = 1
        const val DATABASE_NAME = "IdeaSmsDB.db"
        const val DB_PATH = "/data/user/0/com.ideaxen.hr.ideasms/app_flutter/"
        const val SMS_HISTORY_TABLE = "sms_history_table"
        const val SMS_QUEUE_TABLE = "sms_queue_table"
        const val ID = "id"
        const val MOBILE = "mobileNo"
        const val USER = "userName"
        const val MESSAGE = "message"
        const val DATE = "date"
        const val SENDRESULT = "send"
    }
}
//end