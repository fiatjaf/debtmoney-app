import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> _fdb;

Future<Database> getDB () async {
  var appDocDir = await getApplicationDocumentsDirectory();
  var dbPath = path.join(appDocDir.path, "main.db");

  if (_fdb != null) {
    return await _fdb;
  }

  // deleteDatabase(dbPath).then()

  _fdb = openDatabase(
    dbPath,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute("""
CREATE TABLE peers (
  idx INTEGER PRIMARY KEY,
  id TEXT UNIQUE,
  account TEXT UNIQUE NOT NULL,
  name TEXT,
  show BOOLEAN NOT NULL DEFAULT false
)
      """);

      await db.execute("INSERT INTO peers (idx, account) VALUES (0, '~me~')");

      await db.execute("""
CREATE TABLE things (
  id TEXT PRIMARY KEY,
  name TEXT,
  asset TEXT,
  txn TEXT,
  date DATETIME DEFAULT CURRENT_TIMESTAMP,
  saved BOOLEAN NOT NULL DEFAULT false
)
      """);

      await db.execute("""
CREATE TABLE payers (
  thing TEXT,
  peer INTEGER,
  amount INTEGER,

  FOREIGN KEY(thing) REFERENCES things(id),
  FOREIGN KEY(peer) REFERENCES things(idx)
)
      """);

      await db.execute("""
CREATE TABLE parcels (
  thing TEXT,
  peer INTEGER,
  amount INTEGER,
  
  FOREIGN KEY(thing) REFERENCES things(id),
  FOREIGN KEY(peer) REFERENCES things(idx)
)
      """);
    },
  );

  return await _fdb;
}
