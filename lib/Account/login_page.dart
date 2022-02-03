import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool isLogin = true;
  Duration animationDuration = Duration(microseconds: 270);
  final formkey = GlobalKey<FormState>();

  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isChecked = false;

  void save_user(user_id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('login', user_id);
    return;
  }

  //spring url 입력
  String url = "http://localhost:8080/login";

  Future save() async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': _userIDController.text,
          'password': _passwordController.text
        }));
    print(res.body);

    if (res.body != null) {
      if (_isChecked) {
        save_user(_userIDController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiscoveryPage(user:_userIDController.text)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiscoveryPage(user:_userIDController.text)));
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      showAlertDialog(context, "로그인 실패", "존재하지 않은 계정입니다. \n 관리자에게 문의하세요");
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    // animationController =
    //     AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: <Widget>[
            //close button
            AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: Align(
                alignment: Alignment.topCenter,
                child: InkWell(
                  child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      )),
                  onTap: () {
                    // animationController.reverse();
                    setState(() {
                      isLogin != isLogin;
                    });
                  },
                ),
              ),
            ),

            Align(
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
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "충전 관리 솔루션",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: size.width * 0.03,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "SMART",
                                      style: TextStyle(
                                          fontSize: 38, color: Colors.white),
                                    ),
                                    Text(
                                      "fill",
                                      style: TextStyle(
                                          fontSize: 38, color: Colors.yellow),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Image(
                                image: AssetImage('assets/images/mainimg.png'),
                                width: 80,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.25,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white),
                          child: TextFormField(
                            controller: _userIDController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person, color: Colors.black),
                                hintText: '기사번호 입력',
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword, //inp
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock, color: Colors.black),
                                hintText: '비밀번호',
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: _isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      }),
                                  Text(
                                    "로그인상태 유지",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        InkWell(
                          onTap: () async {
                            save();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white),
                            padding: EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.center,
                            child: Text('로그인',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
