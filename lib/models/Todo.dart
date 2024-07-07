import 'package:flutter_demo/models/Priority.dart';
import 'package:flutter_demo/database/todo.dart';

class Todo {
  late int id;
  late String title;
  late String content;
  late Priority priority;
  late int done;
  late int userId;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    this.priority = Priority.Low,
    this.done = 0,
    required this.userId,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority.toString(),
      'done': done,
      'userId': userId,
    };
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone];
    content = map[columnContent];
    priority = map[columnPriority];
    done = map[columnDone];
    userId = map[columnUserId];
  }

  @override
  String toString() {
    return '''
      Todo {
        id: $id,
        title: $title,
        content: $content,
        priority: $priority,
        done: $done,
        userId: $userId
      }
    ''';
  }
}
