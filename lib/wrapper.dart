import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Account/login_page.dart';
import 'App/Pages/cars/car_number.dart';
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

    } else {
      //uid: providerUserModel.uid
      return CarNumberPage(uid: providerUserModel.uid);
    }
  }
}