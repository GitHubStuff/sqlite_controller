# sqlite_controller

For apps with a single database file, this provides a singleton and useful sqlite helpers. That is, it creates a singleton.

## import statement template

<pre>
import 'package:sqlite_controller/sqlite_controller.dart' as SQL;

final controller = await SQL.SqliteController.initialize(name: 'Test.db');

dropTable(table);
removeDatabase();
</pre>
