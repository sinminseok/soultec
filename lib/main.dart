
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'App/Pages/start_page.dart';
import 'Data/database.dart';
import 'auth.dart';
import 'constants.dart';

void main () async{
  //firebase를 사용 하기 위해선 main 메소드에 알려줘야한다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //StreamProvider 하단에 있는 widget 들은 value 값이 변경될때마다 감지가 가능하다.
    return StreamProvider<DatabaseService?>.value(
      value: AuthService().userState,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          // textTheme: GoogleFonts.roboTextTheme(Theme.of(context).textTheme)
        ),
        home: Start_page()
      ),
    );
  }
}