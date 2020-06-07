import 'package:app_exception/appexception.dart';

class BadLinkException extends AppException {
  BadLinkException([message, int code]) : super(message, 'Bad SQLiteLink', code);
}

class SQLiteRecordNotFoundException extends AppException {
  SQLiteRecordNotFoundException([message, int code]) : super(message, 'Record not found', code);
}
