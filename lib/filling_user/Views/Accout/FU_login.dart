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
import 'package:soultec/nomal_user/View/Account/login_page.dart';
import '../../Presenter/FU_data_controller.dart';
import '../Pages/FU_start_page.dart';

class FU_LoginScreen extends StatefulWidget {
  @override
  _FU_LoginScreen createState() => _FU_LoginScreen();
}

class _FU_LoginScreen extends State<FU_LoginScreen>
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

  //Form controller
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AudioPlayer player = AudioPlayer();

  var check_tutorial_bool;

  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
    }
  }

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

    super.initState();
    initConnectivity();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _controller!.dispose();
    check_tutorial_bool = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
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
                      image: AssetImage('assets/images/smartfill_logo.png'),
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                        color: kPrimaryColor),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "numberfont", fontSize: 23),
                      controller: _userIDController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.black),
                          hintText: '기사번호',
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(4),
                        color: kPrimaryColor),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "numberfont", fontSize: 23),
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
                                  child: LoginScreen()));
                        },
                        child: Text(
                          "일반 기사로 로그인하러가기",
                          style:
                              TextStyle(fontFamily: "numberfont", fontSize: 19),
                        )),
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.5,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      initConnectivity();
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
                                builder: (context) => FutureBuilder<String?>(
                                    future: Provider.of<FU_Http_services>(
                                            context,
                                            listen: false)
                                        .receive_login(
                                      _userIDController.text,
                                      _passwordController.text,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data == "success") {

                                          return FU_Start_page();
                                        }
                                        if (snapshot.data == "false") {

                                          return FU_LoginScreen();
                                        } else {
                                          return Center(
                                              child: Container(
                                            width: size.width * 0.45,
                                            child: Image.asset(
                                              'assets/gifs/login_loading.gif',
                                            ),
                                          ));
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
