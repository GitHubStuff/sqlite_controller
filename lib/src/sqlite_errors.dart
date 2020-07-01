import 'package:app_exception/appexception.dart';

class BadLinkException extends AppException {
  BadLinkException([message, int code]) : super(message, 'Bad SQLiteLink', code);
}

class SQLiteRecordNotFoundException extends AppException {
  SQLiteRecordNotFoundException([message, int code]) : super(message, 'Record not found', code);
}

class SQLiteCannotGetDatabasePath extends AppException {
  SQLiteCannotGetDatabasePath([message, int code]) : super(message, 'Cannot handle path', code);
}

class SQLiteFailedToInitializeDatabase extends AppException {
  SQLiteFailedToInitializeDatabase([message, int code]) : super(message, 'Cannot initialize database', code);
}

class SQLiteCannotParseItem extends AppException {
  SQLiteCannotParseItem([message, int code]) : super(message, 'Cannot parse item', code);
}
