import 'package:flutter/material.dart';

class User {
  final int id;
  final String email;
  final String photoUrl;
  final String userName;
  final String token;

  User(
      {@required this.id,
      @required this.userName,
      @required this.photoUrl,
      @required this.email,
      @required this.token});

  User.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['email'] != null),
        assert(map['userName'] != null),
        assert(map['token'] != null),
        id = map['category'],
        email = map['email'],
        userName = map['userName'],
        token = map['name'],
        photoUrl = map['photoUrl'];
}
