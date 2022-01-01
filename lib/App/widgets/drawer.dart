

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../auth.dart';
import '../../constants.dart';

Widget My_Drawer(){
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(

          decoration: BoxDecoration(
            color: kPrimaryColor,
          ), child: null,
        ),

        Container(
          child: FlatButton(

            onPressed: (){
              AuthService().signOut();
            }, child: Row(
            children: [
              Icon(Icons.logout),
              Center(child: Text("Logout"),),
            ],
          ),
          ),
        ),
      ],
    ),
  );

}