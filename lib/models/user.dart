import 'package:flutter/material.dart';

class User {
  final int id;
  final String email;
  final String photoUrl;
  final String username;
   final String sex;
    final String phone;
  final String token;

  User( 
      {@required this.id,
      @required this.username,
      @required this.photoUrl,
      @required this.email,
      @required this.token,
      @required  this.sex, 
      @required  this.phone,});

  User.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['email'] != null),
        assert(map['userName'] != null),
        assert(map['token'] != null),
        id = map['category'],
        email = map['email'],
        username = map['userName'],
        token = map['name'],
        photoUrl = map['photoUrl'],
        sex = map['sex'],
        phone = map['phone'];
}
