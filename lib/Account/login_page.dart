import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Bluetooth/blue_scan.dart';
import 'package:soultec/App/Pages/cars/car_number.dart';
import 'package:soultec/App/Pages/start_page.dart';
import 'package:soultec/Data/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import 'package:soultec/Data/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:audioplayers/audioplayers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  //Form controller
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AudioPlayer player = AudioPlayer();

  User_token? user_token;
  //자동로그인 checkbox가 확인되면 get_userinfo 실행해서 저장된 user의 information 을 가져온다
  var disk_user_info = [];



  //디스크에 저장된 id,pw 저장 변수
  String? checkbox_state = null;
  String? user_id_disk;
  String? user_pw_disk;
  bool check_click = false;
  bool _isChecked = false;
  bool auth_login = false;
  bool? http_return;



//http get 비동기 control stream
  late Stream<User_token?> stream;

  //이전에 로그인 할떄 자동 로그인을 체크했는데 알려주는 함수
  void check_box() async {
    final prefs = await SharedPreferences.getInstance();
    checkbox_state = prefs.getString("check_login");

    print(checkbox_state);

    if (checkbox_state != null) {
      disk_user_info = await Http_services().get_userinfo();

      user_id_disk = disk_user_info[0];
      user_pw_disk = disk_user_info[1];

      setState(() {
        auth_login = true;
      });
      //initState 에서 비동기로 반환한 객체 가져와지나? 나주엥 연동후ㅜ 테스트

      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {

      setState(() {
        auth_login = false;
      });
    }
  }

  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile data");
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print("wifi");
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    check_box();
    //이 코드 뭐임?ㅋㅋ
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose(){
    auth_login = false;
    checkbox_state = null;
    user_token = null;
    disk_user_info = [];
    _isChecked = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);
    return auth_login
        ? FutureBuilder<User_token?>(
            future: Provider.of<Http_services>(context, listen: false)
                .auto_login(disk_user_info[0], disk_user_info[1]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("server drop}");
              } else if (snapshot.hasData) {
                return CarNumberPage();
              } else {
                return Center(
                    child: Container(
                  width: size.width * 0.5,
                  child: Image.asset(
                    'assets/gifs/login_loading.gif',
                  ),
                ));
              }
            })
        :
        //자동로그인 체크를 하지 않았을 때
        WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: Stack(
                children: <Widget>[
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.05,
                                      ),
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
                                            "스마트필",
                                            style: TextStyle(
                                                fontSize: 38,
                                                color: Colors.black,fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, top: 60),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/mainimg.png'),
                                      width: 70,
                                    ),
                                  ),
                                ],
                              ),
                             Container(
                                    width: size.width*0.8,
                                    height: size.height*0.2,
                                    child: Image.asset(
                                      'assets/gifs/main_img.gif',
                                    )),

                              Container(

                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                    color: kPrimaryColor),
                                child: TextFormField(

                                  style: TextStyle(
                                      fontFamily: "numberfont", fontSize: 23),
                                  controller: _userIDController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.person,
                                          color: Colors.black),
                                      hintText: '기사번호',
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                    color: kPrimaryColor),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontFamily: "numberfont", fontSize: 23),
                                  controller: _passwordController,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  //inp
                                  decoration: InputDecoration(
                                      icon:
                                          Icon(Icons.lock, color: Colors.black),
                                      hintText: '비밀번호',
                                      border: InputBorder.none),
                                ),
                              ),

                                  Container(
                                    width: size.width * 0.5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [

                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                        value: _isChecked,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _isChecked = value!;
                                                          });
                                                        }),
                                              //   ),
                                              // ),

                                              Text(
                                                "로그인상태 유지",
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.black,
                                                    fontFamily: "numberfont"),
                                              ),
                                            ],

                                        ),
                                      ],
                                    ),
                              ),

                              InkWell(
                                onTap: () async {
                                  Sound().play_sound("assets/mp3/start.mp3");
                                  if (_userIDController.text == "") {
                                    return showtoast("기사번호를 입력해주세요");
                                  }
                                  if (_passwordController.text == "") {
                                    return showtoast("비밀번호를 입력해주세요");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FutureBuilder<
                                                    User_token?>(
                                                future:
                                                    Provider.of<Http_services>(
                                                            context,
                                                            listen: false)
                                                        .login(
                                                            _userIDController
                                                                .text,
                                                            _passwordController
                                                                .text,
                                                            _isChecked),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    if (snapshot.data!.error !=
                                                        null) {
                                                      showtoast(
                                                          "로그인 실패 아이디와 비밀번호를 확인해주세요");
                                                      return LoginScreen();
                                                    } else {
                                                      return Start_page();
                                                    }
                                                  } else {
                                                    return Center(
                                                        child: Container(
                                                      width: size.width * 0.5,
                                                      child: Image.asset(
                                                        'assets/gifs/login_loading.gif',
                                                      ),
                                                    ));
                                                  }
                                                })));
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                    width: size.width * 0.7,
                                    height: size.height * 0.2,
                                    child: Image.asset(
                                      'assets/images/button_login.png',
                                    )),
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
