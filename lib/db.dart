import 'dart:io';
import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDB () async {
  Directory appDocDir = await getApplicationDocumentsDirectory();

  // deleteDatabase(path);

  return openDatabase(path.join(appDocDir.path, "main.db"),
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute("""
CREATE TABLE contacts (
  id TEXT UNIQUE,
  account TEXT UNIQUE NOT NULL,
  name TEXT
);
      """);
    },
  );
}
