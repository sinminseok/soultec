import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/wrapper.dart';

import '../../auth.dart';
import '../../constants.dart';

Widget My_Drawer(BuildContext context){
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
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