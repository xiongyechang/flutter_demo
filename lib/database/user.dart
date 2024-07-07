import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_demo/models/User.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const tableUser = 'users';
const columnId = 'id';
const columnEmail = 'email';
const columnToken = 'token';

class UserProvider {

  static final UserProvider _instance = UserProvider._internal();

  late Database db;

  factory UserProvider() {
    return _instance;
  }

  UserProvider._internal();
  
  Future open() async {
    final databasesPath = await getDatabasesPath();
    db = await openDatabase(
      join(databasesPath, 'user.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE $tableUser(
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnEmail TEXT,
              $columnToken TEXT
            )
          ''',
        );
      },
      version: 1,
    );
  }

  Future<User> insert(User user) async {
    user.id = await db.insert(tableUser, user.toMap());
    return user;
  }

  Future<User?> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableUser,
        columns: [columnId, columnEmail, columnToken],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> hasUser(String email) async {
    List<Map<String, dynamic>> maps = await db.query(tableUser,
        columns: [columnEmail],
        where: '$columnEmail = ?',
        whereArgs: [email],
        limit: 1);
    return maps.isNotEmpty;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await db.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future close() async => db.close();
}