import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class Db {
  Db() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<Database> getDbHandle() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), "prime_db.db"),
            onCreate: (db, version) async {
      Batch batch = db.batch();
      batch.execute(
          "CREATE TABLE user_info(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, company TEXT, address TEXT, gstin TEXT, pin TEXT, email TEXT, contact TEXT)");
      batch.execute(
          "CREATE TABLE unit_master(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, symbol TEXT NOT NULL, uqc TEXT)");
      batch.execute(
          "CREATE TABLE item_master(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, unit TEXT NOT NULL,hsn TEXT,description TEXT,gst double,mrp double,stdRate double,opening double)");
      batch.execute(
          "CREATE TABLE led_master(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, ledParent TEXT NOT NULL,address TEXT,state TEXT,country TEXT,pin TEXT,contact TEXT,email TEXT,gstin TEXT)");
      await batch.commit(noResult: true);
    }, version: 1);

    return database;
  }
}
