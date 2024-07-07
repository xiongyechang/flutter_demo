import 'package:flutter_demo/database/user.dart';

class User {
  late int id;
  late String email;
  late String token;

  User({
    required this.id,
    required this.email,
    required this.token,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'email': email,
      'token': token
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    email = map[columnEmail];
    token = map[columnToken];
  }

  @override
  String toString() {
    return '''
      User {
        id: $id,
        email: $email,
        token: $token
      }
    ''';
  }
}
