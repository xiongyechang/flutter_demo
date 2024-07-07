import 'package:flutter/material.dart';
import 'package:flutter_demo/database/todo.dart';
import 'package:flutter_demo/database/user.dart';
import 'package:flutter_demo/pages/auth/auth_page.dart';
import 'package:flutter_demo/pages/register/register_page.dart';
import 'package:flutter_demo/pages/settings/settings_page.dart';
import 'package:flutter_demo/pages/todo/todo_editor_page.dart';
import 'package:flutter_demo/pages/todo/todo_list_page.dart';
import 'package:flutter_demo/scoped_models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '.env.example.dart';
// 条件导入，选择合适的平台初始化文件
import 'package:flutter_demo/widgets/helpers/database_initializer_mobile.dart' if (dart.library.io) 'package:flutter_demo/widgets/helpers/database_initializer_desktop.dart';

// import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDatabaseFactory();
  await UserProvider().open();
  await TodoProvider().open();
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {

  const TodoApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return TodoAppState();
  }
}

class TodoAppState extends State<TodoApp> {
  late AppModel _model;
  bool _isAuthenticated = false;
  bool _isDarkThemeUsed = false;

  @override
  void initState() {
    _model = AppModel();

    _model.loadSettings();
    _model.autoAuthentication();

    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    _model.themeSubject.listen((bool isDarkThemeUsed) {
      setState(() {
        _isDarkThemeUsed = isDarkThemeUsed;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: _model,
      child: MaterialApp(
        title: Configure.AppName,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: _isDarkThemeUsed ? Brightness.dark : Brightness.light,
          useMaterial3: true,
        ),
        routes: {
          '/': (BuildContext context) =>
          _isAuthenticated ? TodoListPage(_model) : const AuthPage(),
          '/editor': (BuildContext context) =>
          _isAuthenticated ? const TodoEditorPage() : const AuthPage(),
          '/register': (BuildContext context) =>
          _isAuthenticated ? TodoListPage(_model) : const RegisterPage(),
          '/settings': (BuildContext context) =>
          _isAuthenticated ? SettingsPage(_model) : const AuthPage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
            _isAuthenticated ? TodoListPage(_model) : const AuthPage(),
          );
        },
      ),
    );
  }
}

/*
class WebViewApp extends StatefulWidget {
  // const WebViewApp({Key? key}) : super(key: key);
  const WebViewApp({super.key}); // 使用super parameters，简化代码
  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late WebViewController controller;
  @override
  void initState() {
    // TODO: implement initState
  controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          log(progress.toString());
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://baidu.com'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('百度',
          style: TextStyle(
            color: Colors.white, // Set the text color here
            fontSize: 24, // Option
            fontWeight: FontWeight.bold,
            // fontStyle: FontStyle.italic,
            // decoration: TextDecoration.underline, // ally set the font size
            // decorationColor: Colors.amber,
            // decorationThickness: 1,
          ),
        ),
        leading: const Icon(Icons.search, color: Colors.white),
        actions: const [
          Icon(Icons.message, color: Colors.white),
        ],
        toolbarHeight: 56,
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
*/
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/