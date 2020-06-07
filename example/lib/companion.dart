import 'package:sqlite_controller/sqlite_controller.dart' as SQL;

class Companion extends SQL.SQLParse<Companion> {
  @override
  int parentRowid;

  @override
  String parentTableName;

  @override
  int rowid;

  @override
  Map<String, dynamic> toJson() {
    return null;
  }
}
