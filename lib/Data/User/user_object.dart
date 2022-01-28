import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class User {
  String email;
  String password;
  User(this.email, this.password);
}


  // factory User.fromJson(Map<String , dynamic> json){
  //   return User(
  //     driver_id: json['driver_id'],
  //     pw: json['pw']
  //   );


  //http 연결 logic
  // Future<User> fetchUser() async{
  //   final reponse = await http.get(Uri.https(authority, unencodedPath));
  //
  //   if(reponse.statusCode == 200){
  //     return User.fromJson(json.decode(reponse.body));
  //   }else{
  //     throw Exception('Failed to load post');
  //   }
  //
  // }
