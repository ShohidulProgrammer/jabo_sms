//package com.example.sql_db;
//
//import android.content.ContentValues;
//import android.content.Context;
//import android.database.Cursor;
//import android.database.SQLException;
//import android.database.sqlite.SQLiteDatabase;
//import android.database.sqlite.SQLiteOpenHelper;
//
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.OutputStream;
//
//
//public class DBHelper extends SQLiteOpenHelper {
//    private Context myContext;
//    public String DB_PATH = "/data/user/0/com.example.sql_db/app_flutter/";
//    public static String DB_NAME = "SmsDB.db"; // your database name
//    private SQLiteDatabase db;
//    public static final String KEY_ID = "_id";
//    public static String KEY_FRDID = "Frd_id";
//    public static final String KEY_USERID = "User_id";
//    public static final String KEY_MSG = "message";
//    public static final String KEY_TIME = "time";
//    public static final String KEY_SENT = "sent";
//    public static final String KEY_FRDNAME = "Frd_Name";
//    private static final String SMS_HISTORY_TABLE = "sms_history_table";
//    private static final String FILE_URL = "File_url";
//    private static final int DATABASE_VERSION = 1;
//
////  CREATE TABLE "Requst_Table" ("_id"  , "Sender_ID" TEXT, "Sender_Name" TEXT,
////          "Receiver_ID" TEXT, "Receiver_Email" TEXT, "Message" TEXT, "Accept" BOOL)
////  private static final String TABLE_REQ_NAME = "Requst_Table";
////  public static final String KEY_SENDERID = "Sender_ID";
////  public static final String KEY_SENDERNAME = "Sender_Name";
////  public static final String KEY_RECID = "Receiver_ID";
////  public static final String KEY_REC_EMAIL = "Receiver_Email";
////  public static final String KEY_MESG = "Message";
////  public static final String KEY_ACCEPT = "Accept";
//
//    public DBHelper(Context context) {
//        super(context, DB_NAME, null, DATABASE_VERSION);
//
//        if (db != null && db.isOpen())
//            close();
//
//        this.myContext = context;
//
////       try {
////       createDataBase();
////       openDataBase();
////       } catch (IOException e) {
////       e.printStackTrace();
////       }
//
//    }
//
//    public void createDataBase() throws IOException {
//        boolean dbExist = checkDataBase();
//
//        if (dbExist) {
//            // System.out.println("Database Exist");
//        } else {
//            this.getReadableDatabase();
//
//            try {
//                copyDatabase();
//            } catch (IOException e) {
//                throw new Error("Error copying database");
//            }
//        }
//    }
//
//    private void copyDatabase() throws IOException {
//        InputStream input = myContext.getAssets().open(DB_NAME);
//        String outputFileName = DB_PATH + DB_NAME;
//        OutputStream output = new FileOutputStream(outputFileName);
//
//        byte[] buffer = new byte[1024];
//        int length;
//        while ((length = input.read(buffer)) > 0) {
//            output.write(buffer, 0, length);
//        }
//
//        // Close the streams
//        output.flush();
//        output.close();
//        input.close();
//        // System.out.println(DB_NAME + "Database Copied !");
//    }
//
//    @Override
//    public void onCreate(SQLiteDatabase db) {
//
//    }
//
//    @Override
//    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
//
//    }
//
//    public void openDataBase() throws SQLException {
//        // Open the database
//        String myPath = DB_PATH + DB_NAME;
//        db = SQLiteDatabase.openDatabase(myPath, null,SQLiteDatabase.OPEN_READWRITE);
//
//    }
//
//    public boolean isOpen() {
//        if (db != null)
//            return db.isOpen();
//        return false;
//    }
//
//    @Override
//    public synchronized void close() {
//        if (db != null)
//            db.close();
//        super.close();
//    }
//
//    private boolean checkDataBase() {
//        SQLiteDatabase checkDB = null;
//        try {
//            String myPath = DB_PATH + DB_NAME;
//            checkDB = SQLiteDatabase.openDatabase(myPath, null,
//                    SQLiteDatabase.OPEN_READWRITE);
//        } catch (Exception e) {
//        }
//
//        if (checkDB != null) {
//            // System.out.println("Closed");
//            checkDB.close();
//            // System.out.println("My db is:- " + checkDB.isOpen());
//        }
//
//        return checkDB != null ? true : false;
//    }
//
//    public Cursor execCursorQuery(String sql) {
//        Cursor cursor = null;
//        try {
//            cursor = db.rawQuery(sql, null);
//        } catch (Exception e) {
//            // Log.e("Err", e.getMessage());
//        }
//        return cursor;
//    }
//
//    public void execNonQuery(String sql) {
//        try {
//            db.execSQL(sql);
//        } catch (Exception e) {
//            // Log.e("Err", e.getMessage());
//        } finally {
//            // closeDb();
//        }
//    }
//
//    public void insertData(String frdID, String userID, String msg, long currentTimeMillis, int sentid, String frdName,String file) {
//        db = this.getWritableDatabase();
//        ContentValues values = new ContentValues();
//        values.put(KEY_FRDID, frdID);
//        values.put(KEY_USERID, userID);
//        values.put(KEY_MSG, msg);
//        values.put(KEY_TIME, currentTimeMillis);
//        values.put(KEY_SENT, sentid);
//        values.put(KEY_FRDNAME, frdName);
//        values.put(FILE_URL, file);
//
//        db.insert(SMS_HISTORY_TABLE, null, values);
//        db.close();
//    }
//
//    public void update(String file,String Id) {
//        String where;
//        db = this.getWritableDatabase();
//        ContentValues values = new ContentValues();
//        values.put(FILE_URL, file);
//        if (Id != null) {
//            where = "_id=" + Id;
//        }else{
//            where = "_id = (SELECT MAX(_id) FROM sms_history_table)";
//        }
//        db.update(SMS_HISTORY_TABLE, values, where, null);
//        db.close();
//    }
//
//    public Cursor fetchAllItems(String frdId){
//        db = this.getWritableDatabase();
//        Cursor cursor = db.query(SMS_HISTORY_TABLE, new String[]{KEY_ID,KEY_FRDID, KEY_USERID,KEY_MSG, KEY_TIME,KEY_SENT,KEY_FRDNAME,FILE_URL},
//                KEY_FRDID+"="+frdId, null, null, null, null);
//        cursor.moveToFirst();
//        db.close();
//        return cursor;
//    }
//
//    public void delete() {
//        db = this.getWritableDatabase();
//        db.delete(SMS_HISTORY_TABLE,"_id = (SELECT MAX(_id) FROM sms_history_table)", null);
//        db.close();
//    }
//
//
//}
