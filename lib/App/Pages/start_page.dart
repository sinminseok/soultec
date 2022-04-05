import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Account/login_page.dart';
import 'package:soultec/App/Pages/fill/fill_stop.dart';
import 'package:soultec/Data/toast.dart';

class Start_page extends StatefulWidget {
  @override
  _Start_pageState createState() => _Start_pageState();
}

class _Start_pageState extends State<Start_page> {
  @override
  void initState() {
    super.initState();
    initConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

//네트워크 연결 확인 함수
  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: defaultRegisterSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/gtbimg.png'),
                    width: 100,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Text(
                    '빠르고 편한 주입',
                    style: TextStyle(fontSize: 19),
                  ),
                  Text(
                    '스마트필 시작.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Image(
                      image: AssetImage('assets/images/mainimg.png'),
                      width: 140,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Text(
                    "페어링이 시작 됩니다 잠시만 기다려 주십시오.",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    onPressed: () async {
                      // final prefs = await SharedPreferences.getInstance();
                      // prefs.remove('check_login');

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Icon(Icons.bluetooth),
                    splashColor: Colors.blue,
                    color: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
