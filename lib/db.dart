import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Database _db;

Future<Database> _open () async {
  var appDocDir = await getApplicationDocumentsDirectory();
  var dbPath = path.join(appDocDir.path, "main.db");

  // deleteDatabase(dbPath);

  _db = await openDatabase(dbPath,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute("""
CREATE TABLE contacts (
  id TEXT UNIQUE,
  account TEXT UNIQUE NOT NULL,
  name TEXT,
  actual BOOLEAN
);  
      """);
    },
  );

  return _db;
}

Future<Database> getDB () async {
  if (_db != null) {
    return _db;
  }
  return _open();
}
