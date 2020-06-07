import 'package:flutter/material.dart';

import '../sqlite_controller.dart';

/// A class the packages all the information needed (per SQLite standard) for creating, opening, updating and sqlite database
class SQLiteIdentity {
  final String databaseName;
  final int databaseVersion;
  final DBCreate dbCreate;
  final DBUpgrade dbUpgrade;
  SQLiteIdentity({@required this.databaseName, this.databaseVersion = 1, this.dbCreate, this.dbUpgrade})
      : assert(databaseName != null),
        assert(databaseVersion != null && databaseVersion > 0);
}