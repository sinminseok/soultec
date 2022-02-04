import 'dart:core';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';
import 'package:soultec/Data/User/user_object.dart';
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

  //Form controller
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  //User 객체 생성, http get 이후 json을 데이터를 User 객체로 대입
  User? user;

  //디스크에 저장된 id,pw 저장 변수
  String? checkbox_state;
  String? user_id;
  String? user_pw;
  bool _isChecked = false;


  //spring url 입력
  String url = "http://localhost:8080/login";


  void save_user(user_id ,user_pw) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('check_login', "true");
    prefs.setString('id', user_id);
    prefs.setString('pw', user_pw);
    return;
  }

  //자동로그인 checkbox가 확인되면 get_userinfo 실행해서 저장된 user의 information 을 가져온다
  Future<String?> get_userinfo() async {
    final prefs = await SharedPreferences.getInstance();
// counter 키에 해당하는 데이터 읽기를 시도합니다. 만약 존재하지 않는 다면 0을 반환합니다.
     user_id = prefs.getString('id');
     user_pw = prefs.getString('pw');
     return null;
  }

  //이전에 로그인 할떄 자동 로그인을 체크했는데 알려주는 함수
  void check_box()async{
    final prefs = await SharedPreferences.getInstance();
    checkbox_state = prefs.getString("check_login");

  }




  Future save() async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': _userIDController.text,
          'password': _passwordController.text
        }));

    print(res.body);

    //res body 를 User 로 형변환
    user = res as User?;

    if (user != null) {
      if (_isChecked) {
        save_user(_userIDController.text , _passwordController.text);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiscoveryPage(user:user)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiscoveryPage(user:user)));
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      showAlertDialog(context, "로그인 실패", "존재하지 않은 계정입니다. \n 관리자에게 문의하세요");
    }
  }

  Future auto_login(user_id,user_pw) async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user-id': user_id,
          'password': user_pw
        }));
    print(res.body);

    user = res as User?;

    if (user != null) {
    {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DiscoveryPage(user: user)));
        //디스크에 해당 user id,pw 저장후 로그인

      }
    } else {
      showAlertDialog(context, "로그인 실패", "존재하지 않은 계정입니다. \n 관리자에게 문의하세요");
    }
  }

  @override
  void initState() {
    super.initState();
      check_box();
      if(checkbox_state != null){
        get_userinfo();
        auto_login(user_id,user_pw);
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
      //이 코드 뭐임?ㅋㅋ
      SystemChrome.setEnabledSystemUIOverlays([]);

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
