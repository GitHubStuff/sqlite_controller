import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:hud_scaffold/hud_scaffold.dart';
import 'package:mode_theme/mode_theme.dart';
import 'package:tracers/tracers.dart' as Log;
import 'package:sqlite_controller/sqlite_controller.dart' as SQL;

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Log.SetLevel(Log.VERBOSE);
    return ModeTheme(
      themeDataFunction: (brightness) => (brightness == Brightness.light) ? ModeTheme.light : ModeTheme.dark,
      defaultBrightness: Brightness.light,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          home: Example(),
          initialRoute: '/',
          routes: {
            Example.route: (context) => ExampleApp(),
          },
          theme: theme,
          title: 'Example Demo',
        );
      },
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key key}) : super(key: key);
  static const route = '/example';

  @override
  _Example createState() => _Example();
}

class _Example extends State<Example> with WidgetsBindingObserver, AfterLayoutMixin<Example> {
  bool hideSpinner = true;

  // ignore: non_constant_identifier_names
  Size get ScreenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Log.t('example initState()');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Log.t('example afterFirstLayout()');
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Log.t('example didChangeDependencies()');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.t('example didChangeAppLifecycleState ${state.toString()}');
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    ModeTheme.of(context).setBrightness(brightness);
    Log.t('example didChangePlatformBrightness ${brightness.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    Log.t('example build()');
    return HudScaffold.progressText(
      context,
      hide: hideSpinner,
      indicatorColors: ModeColor(light: Colors.purpleAccent, dark: Colors.greenAccent),
      progressText: 'Example Showable spinner {does nothing}',
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text('Title: Create/Delete database'),
        ),
        body: body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              hideSpinner = false;
              Future.delayed(Duration(seconds: 3), () {
                setState(() {
                  hideSpinner = true;
                });
              });
            });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    Log.t('example didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    Log.t('example deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    Log.t('example dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Scaffold body
  Widget body() {
    Log.t('example body()');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Example Template', style: Theme.of(context).textTheme.headline5),
          RaisedButton(
            child: Text('Test Database', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
              _testDatabase();
            },
          ),
          Container(height: 100),
          RaisedButton(
            child: Text('Toggle Mode', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              ModeTheme.of(context).toggleBrightness();
            },
          ),
          RaisedButton(
            child: Text('Light Mode', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
              ModeTheme.of(context).setBrightness(Brightness.light);
            },
          ),
          RaisedButton(
            child: Text('Dark Mode', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
              ModeTheme.of(context).setBrightness(Brightness.dark);
            },
          ),
        ],
      ),
    );
  }

  void _testDatabase() async {
    final controller = await SQL.SqliteController.initialize(name: 'Test.db');
    Log.v('main.dart: Database path ${controller.fullPathName}');
    assert(SQL.SqliteController.database != null);
    final removal = await controller.removeDatabase();
    Log.v('main.dart: return after "removeDatabase" :$removal');
  }
}
