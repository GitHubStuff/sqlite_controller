import 'package:tracers/tracers.dart' as Log;

import '../sqlite_controller.dart';

/// Sqlite/Json helpers
///
///
String dateString(dynamic data) {
  if (data == null) return null;
  if (data is String) {
    try {
      final result = DateTime.parse(data).toUtc();
      return result.toIso8601String();
    } catch (e) {
      final message = 'flutter_sqlite_controller: ${e.toString()}';
      Log.e(message);
      throw SQLiteCannotParseItem(message, 1004);
    }
  }
  if (data is DateTime) {
    return data.toUtc().toIso8601String();
  }
  final message = 'flutter_sqlite_controller: cannot time parse ${data.toString()}';
  Log.e(message);
  throw SQLiteCannotParseItem(message, 1004);
}

DateTime getDateTime(dynamic date) {
  if (date == null) return null;
  if (date is String) {
    try {
      final result = DateTime.parse(date).toUtc();
      return result;
    } catch (e) {
      SQLiteCannotParseItem(date, 1004);
    }
  }
  if (date is DateTime) return date;
  final message = 'flutter_sqlite_controller - Cannot parse ${date.toString()}';
  Log.e(message);
  throw SQLiteCannotParseItem(message, 1004);
}

bool getBoolean(dynamic boolean) {
  if (boolean == null) return null;
  if (boolean is bool) return boolean;
  if (boolean is int) {
    final int value = boolean;
    if (value == 0 || value == 1) return (value == 1);
    final message = 'flutter_sqlite_controller - Invalid number for boolean: $value';
    Log.e(message);
    throw SQLiteCannotParseItem(message, 1004);
  }
  if (!(boolean is String)) {
    final message = 'flutter_sqlite_controller - Cannot parse ${boolean.toString()}';
    Log.e(message);
    throw SQLiteCannotParseItem(message, 1004);
  }

  final String value = boolean.toLowerCase();
  switch (value) {
    case '1':
    case 't':
    case 'true':
    case 'y':
    case 'yes':
      return true;
    case '0':
    case 'f':
    case 'false':
    case 'n':
    case 'no':
      return false;
    default:
      final message = 'flutter_sqlite_controller - Invalid string for boolean: $value';
      Log.e(message);
      throw SQLiteCannotParseItem(message, 1004);
  }
}
