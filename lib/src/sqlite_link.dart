import '../sqlite_controller.dart';

/// This class manages the 'hidden' fields in the SQLite table that allows an an object or array to be store in
/// another table but still linked to table tha has class or arrays as properties.
class SQLiteLink {
  final int rowid;
  final String tableName;
  SQLiteLink({this.rowid = 0, this.tableName = ''});

  factory SQLiteLink.fromMap(
    Map<String, dynamic> map, {
    String rowidKey = parentRowidKey,
    String tableNameKey = parentTableNameKey,
  }) {
    assert(rowidKey != null);
    assert(map[rowidKey] != null);
    assert(tableNameKey != null);
    assert(map[tableNameKey] != null);
    return SQLiteLink(rowid: map[rowidKey], tableName: map[tableNameKey]);
  }

  String get clause => '($parentRowidKey = $rowid AND $parentTableNameKey = "$tableName")';
}
