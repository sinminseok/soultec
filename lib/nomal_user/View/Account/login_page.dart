import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Utils/sound.dart';
import 'package:soultec/Utils/toast.dart';
import 'package:soultec/Utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:soultec/filling_user/Views/Accout/FU_login.dart';
import '../../../Utils/permission.dart';
import '../../../filling_user/Presenter/FU_data_controller.dart';
import '../../../filling_user/Views/Pages/FU_start_page.dart';
import '../../Model/User_Model.dart';
import '../../Presenter/data_controller.dart';
import '../Bluetooth/blue_scan.dart';
import '../Pages/start_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  //튜토리얼 애니메이션
  int interval = 500;
  AnimationController? _controller;
  int _currentWidget = 0;

  List<Widget> children = [
    Image.asset(
      "assets/images/arrow.png",
    ),
    Image.asset(
      "assets/images/arrow.png",
      color: Colors.transparent,
    ),
  ];

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

  //디스크에 저장할 id,pw 추후 비밀화
  String? user_id_disk;
  String? user_pw_disk;

  bool _isChecked = false;
  bool auth_login = false;
  bool? http_return;

  var check_tutorial_bool;

//http get 비동기 control stream
  late Stream<User_token?> stream;

  //이전에 로그인 할떄 자동 로그인을 체크했는데 알려주는 함수
  void check_box() async {
    final prefs = await SharedPreferences.getInstance();
    checkbox_state = prefs.getString("check_login");
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

  // Future<void> initConnectivity() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     // I am connected to a wifi network.
  //   } else if (connectivityResult.toString() == "ConnectivityResult.none") {
  //     showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
  //   }
  // }

  void check_tutorial() async {
    final prefs = await SharedPreferences.getInstance();
    check_tutorial_bool = prefs.get('check_tutorial');
  }

  @override
  void initState() {
    _controller = new AnimationController(
        duration: Duration(milliseconds: interval), vsync: this);

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == children.length) {
            _currentWidget = 0;
          }
        });

        _controller!.forward(from: 0.0);
      }
    });

    _controller!.forward();
    Permission_handler().initConnectivity(context);
    check_box();
    super.initState();

    //이 코드 뭐임?ㅋㅋ
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _userIDController.dispose();
    _passwordController.dispose();
    _controller!.dispose();
    check_tutorial_bool = null;
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
    var check_tutorial = Provider.of<Http_services>(context).check_tutorial;

    return auth_login
        ? FutureBuilder<User_token?>(
            future: Provider.of<Http_services>(context, listen: false)
                .auto_login(disk_user_info[0], disk_user_info[1]),
            builder: (context, snapshot) {
              if (snapshot.hasError){
                return Text("server drop");
              } else if (snapshot.hasData) {
                return Blue_scan();
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
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.07),
                        Container(
                          width: size.width * 0.6,
                          child: Image(
                            image:
                                AssetImage('assets/images/smartfill_logo.png'),
                            width: 70,
                          ),
                        ),
                        Container(
                            width: size.width * 0.65,
                            height: size.height * 0.2,
                            child: Image.asset(
                              'assets/gifs/main_img.gif',
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4),
                              color: kPrimaryColor),
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: "numberfont", fontSize: 23),
                            controller: _userIDController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person, color: Colors.black),
                                hintText: '기사번호',
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.7,
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
                                icon: Icon(Icons.lock, color: Colors.black),
                                hintText: '비밀번호',
                                border: InputBorder.none),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {

                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: FU_LoginScreen()));
                              },
                              child: Text(
                                "입고자로 로그인하러 가기",
                                style: TextStyle(
                                    fontFamily: "numberfont", fontSize: 19),
                              )),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.25,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Colors.black,
                                            fontFamily: "numberfont"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            check_tutorial != null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Container(
                                      width: size.width * 0.1,
                                      child: children[_currentWidget],
                                    ),
                                  ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: Container(
                            //       child: Icon(
                            //     Icons.call_received,
                            //     size: 37,
                            //   )),
                            // )
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            Permission_handler().initConnectivity(context);
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
                                          future: Provider.of<Http_services>(
                                                  context,
                                                  listen: false)
                                              .login(
                                                  _userIDController.text,
                                                  _passwordController.text,
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
                                                width: size.width * 0.45,
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
                ],
              ),
            ),
          );
  }
}
