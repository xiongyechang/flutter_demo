import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_demo/models/Todo.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const tableTodo = 'todos';
const columnId = 'id';
const columnTitle = 'title';
const columnContent = 'content';
const columnPriority = 'priority';
const columnDone = 'done';
const columnUserId = 'userId';

class TodoProvider {
  
  static final TodoProvider _instance = TodoProvider._internal();
  
  late Database db;

  factory TodoProvider() {
    return _instance;
  }

  TodoProvider._internal();

  Future open() async {
    final databasesPath = await getDatabasesPath();
    db = await openDatabase(
      join(databasesPath, 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE $tableTodo(
              $columnId INTEGER PRIMARY KEY autoincrement,
              $columnTitle TEXT,
              $columnContent TEXT,
              $columnPriority INTEGER,
              $columnDone INTEGER,
              $columnUserId TEXT
            )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo?> getTodo(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableTodo,
        columns: [columnId, columnTitle, columnContent, columnPriority, columnDone, columnUserId],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(), where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}