import 'dart:async';
import 'dart:developer';
import 'package:flutter_demo/database/todo.dart';
import 'package:flutter_demo/database/user.dart';
import 'package:flutter_demo/widgets/helpers/common.dart';
import 'package:flutter_demo/widgets/ui_elements/toast.dart';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_demo/widgets/helpers/priority_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:flutter_demo/models/Filter.dart';
import 'package:flutter_demo/models/User.dart';
import 'package:flutter_demo/models/Priority.dart';
import 'package:flutter_demo/models/Setting.dart';


mixin CoreModel on Model {
  List<Todo> _todos = [];
  Todo? _todo;
  bool _isLoading = false;
  Filter _filter = Filter.All;
  User? _user;
}

mixin TodosModel on CoreModel {
  List<Todo> get todos {
    switch (_filter) {
      case Filter.All:
        return List.from(_todos);
      case Filter.Done:
        return List.from(_todos.where((todo) => todo.done == 1));
      case Filter.NotDone:
        return List.from(_todos.where((todo) => todo.done == 0));
    }
  }

  Filter get filter {
    return _filter;
  }

  bool get isLoading {
    return _isLoading;
  }

  Todo? get currentTodo {
    return _todo;
  }

  void applyFilter(Filter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCurrentTodo(Todo? todo) {
    _todo = todo;
  }

  Future fetchTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      // final http.Response response = await http.get(
      //     '${Configure.FirebaseUrl}/todos.json?auth=${_user.token}&orderBy="userId"&equalTo="${_user.id}"');


      const statusCode = 200;
      const body = '''
        [
          {
            "title": "我的任务",
            "content": "开发完flutter",
            "priority": 1,
            "done": false
          }
        ]
      '''
      ;


      if (statusCode != 200 && statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final Map<String, dynamic> todoListData = json.decode(body);

      if (todoListData.isEmpty) {
        _isLoading = false;
        notifyListeners();

        return;
      }

      todoListData.forEach((String todoId, dynamic todoData) {
        final Todo todo = Todo(
          id: int.parse(todoId),
          title: todoData['title'],
          content: todoData['content'],
          priority: PriorityHelper.toPriority(todoData['priority']),
          done: todoData['done'],
          userId: _user!.id,
        );

        _todos.add(todo);
      });

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTodo(String title, String content, Priority priority, int done) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> formData = {
      'id': Common.generateRandomNegativeInt(),
      'title': title,
      'content': content,
      'priority': priority,
      'done': done,
      'userId': _user!.id,
    };

    try {
      // final http.Response response = await http.post(
      //   '${Configure.FirebaseUrl}/todos.json?auth=${_user.token}',
      //   body: json.encode(formData),
      // );

      const statusCode = 200;

      // const body = """
      //   {
      //     "name": "我的任务"
      //   }
      // """;

      if (statusCode != 200 && statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      // final Map<String, dynamic> responseData = json.decode(body);

      final TodoProvider todoProvider = TodoProvider();

      final Todo t = Todo.fromMap(formData);

      Todo todo = await todoProvider.insert(t);
      // Todo(
      //   id: responseData['name'],
      //   title: title,
      //   content: content,
      //   priority: priority,
      //   done: done,
      //   userId: _user!.id,
      // );
      _todos.add(todo);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> updateTodo(
      String title, String content, Priority priority, int done) async {
    _isLoading = true;
    notifyListeners();

    // final Map<String, dynamic> formData = {
    //   'title': title,
    //   'content': content,
    //   'priority': priority.toString(),
    //   'done': done,
    //   'userId': _user!.id,
    // };

    try {
      // final http.Response response = await http.put(
      //   '${Configure.FirebaseUrl}/todos/${currentTodo.id}.json?auth=${_user.token}',
      //   body: json.encode(formData),
      // );

      const statusCode = 200;

      if (statusCode != 200 && statusCode != 201) {
        _isLoading = false;
        notifyListeners();

        return false;
      }

      Todo todo = Todo(
        id: currentTodo!.id,
        title: title,
        content: content,
        priority: priority,
        done: done,
        userId: _user!.id,
      );
      int todoIndex = _todos.indexWhere((t) => t.id == currentTodo!.id);
      _todos[todoIndex] = todo;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> removeTodo(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      Todo todo = _todos.firstWhere((t) => t.id == id);
      int todoIndex = _todos.indexWhere((t) => t.id == id);
      _todos.removeAt(todoIndex);

      // final http.Response response = await http.delete(
      //     '${Configure.FirebaseUrl}/todos/$id.json?auth=${_user.token}');

      const statusCode = 200;

      if (statusCode != 200 && statusCode != 201) {
        _todos[todoIndex] = todo;

        _isLoading = false;
        notifyListeners();

        return false;
      }

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> toggleDone(int id) async {
    _isLoading = true;
    notifyListeners();

    Todo todo = _todos.firstWhere((t) => t.id == id);
    todo.done = todo.done == 1 ? 0 : 1;

    try {
      const statusCode = 200;
      if (statusCode != 200 && statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }
}

mixin UserModel on CoreModel {
  late Timer _authTimer;
  final PublishSubject<bool> _userSubject = PublishSubject();

  User? get user {
    return _user;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // final Map<String, dynamic> formData = {
    //   'email': email,
    //   'password': password,
    //   'returnSecureToken': true,
    // };

    try {
      // final http.Response response = await http.post(
      //   'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${Configure.ApiKey}',
      //   body: json.encode(formData),
      //   headers: {'Content-Type': 'application/json'},
      // );

      String body = '''
        {
          "idToken": "1111111",
          "localId": 2222222,
          "email": "123456789@123.com",
          "expiresIn": 1719983526548,
          "refreshToken": "12345678909876545678908765432"
        }
      ''';

      final Map<String, dynamic> responseData = json.decode(body);
      String message = '操作成功';

      if (responseData.containsKey('idToken')) {
        _user = User(
          id: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken'],
        );

        setAuthTimeout(responseData['expiresIn']);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: responseData['expiresIn']));

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', responseData['localId'].toString());
        prefs.setString('email', responseData['email']);
        prefs.setString('token', responseData['idToken']);
        prefs.setString('refreshToken', responseData['refreshToken']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());

        _userSubject.add(true);

        _isLoading = false;
        notifyListeners();

        return {'success': true};
      } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        message = 'Email is not found.';
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        message = 'Password is invalid.';
      } else if (responseData['error']['message'] == 'USER_DISABLED') {
        message = 'The user account has been disabled.';
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': message,
      };
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return {'success': false, 'message': error};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final UserProvider userProvider = UserProvider();

    final bool hasUser = await userProvider.hasUser(email);

    log(hasUser.toString());

    if (hasUser) {
      String message = 'This email already exists';
      MyToast.show(message);
      return {
        'success': false,
        'message': message,
      };
    }

    try {
      const String idToken = '12345678987654323456789876543456789';

      User user = User(id: -1, email: email, token: idToken);

      User insertedUser = await userProvider.insert(user);

      log(insertedUser.toString());

      String body = '''
        {
          "idToken": $idToken,
          "localId": "2222222",
          "email": $email,
          "expiresIn": 1719983526548,
          "refreshToken": "123456789876543212345678"
        }
      ''';

      final Map<String, dynamic> responseData = json.decode(body);
      String message = '操作成功';

      if (responseData.containsKey('idToken')) {
        _user = User(
          id: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken'],
        );

        setAuthTimeout(responseData['expiresIn']);

        final DateTime now = DateTime.now();
        final DateTime expiryTime = now.add(Duration(seconds: responseData['expiresIn']));

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', responseData['localId']);
        prefs.setString('email', responseData['email']);
        prefs.setString('token', responseData['idToken']);
        prefs.setString('refreshToken', responseData['refreshToken']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());

        _userSubject.add(true);

        _isLoading = false;
        notifyListeners();

        return {'success': true};
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        message = 'Email is already exists.';
      } else if (responseData['error']['message'] == 'OPERATION_NOT_ALLOWED') {
        message = 'Password sign-in is disabled.';
      } else if (responseData['error']['message'] == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
        message = 'We have blocked all requests from this device due to unusual activity. Try again later.';
      }

      _isLoading = false;
      notifyListeners();

      return {
        'success': false,
        'message': message,
      };
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      return {'success': false, 'message': error};
    }
  }

  void logout() async {
    _todos = [];
    _todo = null;
    _filter = Filter.All;
    _user = null;

    _authTimer.cancel();

    _userSubject.add(false);

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    if (token.isNotEmpty) {
      // final String expiryTimeString = prefs.getString('expiryTime') ?? '';
      // final DateTime now = DateTime.now();
      // final parsedExpiryTime = DateTime.parse(expiryTimeString);

      // if (parsedExpiryTime.isBefore(now)) {
      //   _user = null;
      //   return;
      // }

      final String? expiryTimeString = prefs.getString('expiryTime');
      final DateTime now = DateTime.now();
      late DateTime? parsedExpiryTime;

      if (expiryTimeString != null && expiryTimeString.isNotEmpty) {
        parsedExpiryTime = DateTime.tryParse(expiryTimeString);
        if (parsedExpiryTime != null && parsedExpiryTime.isBefore(now)) {
          _user = null;
          return;
        }
      } else {
        _user = null; // 处理 expiryTimeString 为空的情况
        return;
      }

      final String? userIdString = prefs.getString('userId');

      if (userIdString != null) {
        _user = User(
          id: int.parse(userIdString),
          email: prefs.getString('email') as String,
          token: token,
        );
      }      

      final int tokenLifespan = parsedExpiryTime!.difference(now).inSeconds;
      setAuthTimeout(tokenLifespan);

      _userSubject.add(true);
    }
  }

  void tryRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    // final refreshToken = prefs.getString('refreshToken');

    // final Map<String, dynamic> formData = {
    //   'grant_type': 'refresh_token',
    //   'refresh_token': refreshToken
    // };

    try {
      // final http.Response response = await http.post(
      //   'https://securetoken.googleapis.com/v1/token?key=${Configure.ApiKey}',
      //   body: json.encode(formData),
      //   headers: {'Content-Type': 'application/json'},
      // );

      String body = '''
        {
          "idToken": "1111111",
          "localId": "2222222",
          "email": "123456789@123.com",
          "expiresIn": 1719983526548
        }
      ''';

      final Map<String, dynamic> responseData = json.decode(body);

      if (responseData.containsKey('id_token')) {
        _user = User(
          id: prefs.getString('userId') as int,
          email: prefs.getString('email') as String,
          token: responseData['id_token'],
        );

        setAuthTimeout(int.parse(responseData['expires_in']));

        final DateTime now = DateTime.now();
        final DateTime expiryTime =
        now.add(Duration(seconds: int.parse(responseData['expires_in'])));

        prefs.setString('token', responseData['id_token']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
        prefs.setString('refreshToken', responseData['refresh_token']);

        return;
      }
    } catch (error) {
      // _isLoading = false;
      // notifyListeners();
    }

    logout();
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), tryRefreshToken);
  }
}

mixin SettingsModel on CoreModel {
  late Settings _settings;
  final PublishSubject<bool> _themeSubject = PublishSubject();

  Settings get settings {
    return _settings;
  }

  PublishSubject<bool> get themeSubject {
    return _themeSubject;
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkThemeUsed = _loadIsDarkThemeUsed(prefs);

    _settings = Settings(
      isShortcutsEnabled: _loadIsShortcutsEnabled(prefs),
      isDarkThemeUsed: isDarkThemeUsed,
    );

    _themeSubject.add(isDarkThemeUsed);
  }

  bool _loadIsShortcutsEnabled(SharedPreferences prefs) {
    return prefs.getBool('isShortcutsEnabled') ?? false;
  }

  bool _loadIsDarkThemeUsed(SharedPreferences prefs) {
    return prefs.getBool('isDarkThemeUsed') ?? false;
  }

  Future toggleIsShortcutEnabled() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isShortcutsEnabled', !_loadIsShortcutsEnabled(prefs));

    _settings = Settings(
      isShortcutsEnabled: _loadIsShortcutsEnabled(prefs),
      isDarkThemeUsed: _loadIsDarkThemeUsed(prefs),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future toggleIsDarkThemeUsed() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final isDarkThemeUsed = !_loadIsDarkThemeUsed(prefs);
    prefs.setBool('isDarkThemeUsed', isDarkThemeUsed);

    _themeSubject.add(isDarkThemeUsed);

    _settings = Settings(
      isShortcutsEnabled: _loadIsShortcutsEnabled(prefs),
      isDarkThemeUsed: _loadIsDarkThemeUsed(prefs),
    );

    _isLoading = false;
    notifyListeners();
  }
}

