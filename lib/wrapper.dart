import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/home_page.dart';

import 'Account/login_main.dart';
import 'App/Pages/car_number.dart';
import 'Data/database.dart';



class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //부모 위젯에서 받은 providerUserModel을이용해 현재 유저의 uid 를 가져왔다.
    final providerUserModel = Provider.of<DatabaseService?>(context);
    print('wrapper_page');
    //return either Home or Authenticate widget
    if (providerUserModel == null) {
      return LoginScreen();
          //Sign_Page();
    } else {
      //uid: providerUserModel.uid
      return CarNumberPage(uid: providerUserModel.uid);
    }
  }
}