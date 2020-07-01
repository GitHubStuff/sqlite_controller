library sqlite_controller;

import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracers/tracers.dart' as Log;

import 'src/sqlite_errors.dart';

export 'src/sql_helpers.dart';
export 'src/sql_parse.dart';
export 'src/sqlite_errors.dart';
export 'src/sqlite_identity.dart';

///--
/// As part of the sqflite flutter package sqlite uses a callback method on database initialize to allow
/// for modifications on database create and allow for changes when updating version. These typedef's add
/// clarity to purpose
typedef DBCreate = Future<void> Function(Database db, int old, [int newv]);
typedef DBUpgrade = Future<void> Function(Database db, int old, [int newv]);

const String rowidKey = 'rowid';

class SqliteController {
  /// For this to have value the static method 'initialize' has to be have been called at least once.
  /// This is a convenience getter.
  static Database get database => _singleton?._databaseSingleton;

  static SqliteController _singleton;

  final Database _databaseSingleton;
  final String name;
  final String fullPathName;

  /// A private initializer is used to prevent accidental attempts to create a controller with 'SqliteController()'
  /// because database set up is an async process and must go through the static 'initialize()' method.
  SqliteController._private(this._databaseSingleton, this.name, this.fullPathName);

  /// As SQLite is stored on the device, a database path to the name of a usable
  /// directory is needed for both iOS/Android platforms. For simplified error checking
  /// the method returns the path(as a String) on success or error(as dynamic). This
  /// allows for checking using 'is' operator on the type returned.
  static Future<dynamic> _getDatabasePath(String databaseName) async {
    if (databaseName == null) {
      Log.e('{sqlite_controller.dart} Database name is null');
      throw SQLiteCannotGetDatabasePath('Database name is null', 1001);
    }

    try {
      /// Get a path from the package that is device specific

      String databasePath = await getDatabasesPath();

      /// Join the path to the supplied database file name and create any directory space
      /// and return the name
      final path = Path.join(databasePath, databaseName);
      if (!await Directory(Path.dirname(path)).exists()) {
        await Directory(Path.dirname(path)).create(recursive: true);
      }
      return path;
    } catch (error) {
      Log.e('{sqlite_controller.dart} ${error.toString()}');
      throw SQLiteCannotGetDatabasePath(error.toString(), 1000);
    }
  }

  /// **NOTE**
  /// This is the gateway method to creating the sqlite singleton for the single database file
  /// used by the application. The use of static initializer is needed because database creation
  /// is series of async operations that could not be done by a simple initializer.
  /// There is no details returned on error, just null on failure.
  /// Per sqlite convention optional Create and Update callbacks can be passed, the default
  /// version of the database is 1, any other value implies an upgrade and should be handled
  /// per sqlite convention.
  static Future<SqliteController> initialize({
    @required String name,
    int version = 1,
    DBCreate create,
    DBUpgrade upgrade,
  }) async {
    if (name == null) {
      Log.e('{sqlite_controller.dart} Database name is null');
      throw SQLiteCannotGetDatabasePath('Database name is null', 1001);
    }
    try {
      /// If there already is an instance, check if the version number passed is different than
      /// than the current version of singleton, if they are different this means a probably upgrade
      /// to the database file is occurring, so the current database file is closed and one with
      /// the new version is created/updated.
      if (_singleton != null) {
        int currentVersion = await _singleton._databaseSingleton.getVersion();
        if (currentVersion == version) {
          return _singleton;
        } else {
          await _singleton._databaseSingleton.close();
        }
      }

      /// Try to create a path to the database file location (path will be specific to iOS/Android)
      final path = await _getDatabasePath(name);
      if (!(path is String)) return null;
      final database = await openDatabase(path, version: version, onCreate: create, onUpgrade: upgrade);
      _singleton = SqliteController._private(database, name, path);
      return _singleton;
    } catch (error) {
      Log.e('{sqlite_controller.dart} ${error.toString()}');
      throw SQLiteFailedToInitializeDatabase('Could not initialize database $name, ${error.toString()}', 1002);
    }
  }

  Future<dynamic> drop(String table) async {
    assert(table != null);
    final sql = 'DROP TABLE IF EXISTS $table';
    try {
      await _databaseSingleton.execute(sql);
      return null;
    } catch (error) {
      Log.e('{sqlite_controller.dart} ${error.toString()}');
      throw SQLiteFailedToInitializeDatabase('Could not drop table $name, ${error.toString()}', 1005);
    }
  }

  Future<dynamic> removeDatabase() async {
    try {
      if (fullPathName == null) return null;
      _databaseSingleton.close();
      final directory = Directory(fullPathName);
      await directory.delete(recursive: true);
      _singleton = null;
      return null;
    } catch (error) {
      Log.e('{sqlite_controller.dart} ${error.toString()}');
      throw SQLiteFailedToInitializeDatabase('Could not removeDatabase, ${error.toString()}', 1005);
    }
  }
}
