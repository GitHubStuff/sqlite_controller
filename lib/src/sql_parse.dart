/// Any class that will bridge/link to sqlite records should 'extend' this class to have access to 'className' used by
/// in the bridging logic and enforce creation of 'toJson()' helper needed for serialize and de-serialize of objects
abstract class SQLParse<T> {
  Map<String, dynamic> toJson();

  String _className;
  String get className => _className ?? '$T';

  String _parentTableName;
  String get parentTableName => _parentTableName ?? '';
  set parentTableName(String name) => _parentTableName = name ?? '';

  int _parentRowid;
  int get parentRowid => _parentRowid ?? 0;
  set parentRowid(int row) => _parentRowid = row ?? 0;

  int _rowid;
  int get rowid => _rowid ?? 0;
  set rowid(int newValue) => _rowid = newValue ?? 0;

  List<Map<String, dynamic>> jsonArray<U>(List<U> data) {
    List<Map<String, dynamic>> result = List();
    for (U item in data) {
      final vector = (item as SQLParse);
      final data = vector.toJson();
      result.add(data);
    }
    return result;
  }
}
