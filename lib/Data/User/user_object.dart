import 'package:flutter/cupertino.dart';

class User {
  final int? userID;
  final String? token;
  final String? title;


  User({this.userID, this.token, this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userId'],
      token: json['title'],
      title: json['body'],
    );
  }
}




