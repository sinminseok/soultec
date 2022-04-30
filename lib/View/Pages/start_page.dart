import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:soultec/View/Pages/cars/car_number.dart';
import 'package:soultec/Presenter/data_controller.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:page_transition/page_transition.dart';

import '../../Utils/constants.dart';
import '../../Utils/sound.dart';
import '../../Utils/toast.dart';

class Start_page extends StatefulWidget {
  //자동차 번호 전역으로 돌려줘야되는데 왜인진 모르겠는데 provider가 안먹어서 일단 위젯으로 데이터 넘김 추후 변경

  @override
  _Start_page createState() => _Start_page();
}

class _Start_page extends State<Start_page>
    with SingleTickerProviderStateMixin {

  //
  var check_tutorial_bool;
  List<Widget> children = [
    Image.asset("assets/images/arrow.png",),
    Image.asset("assets/images/arrow.png",color: Colors.transparent,),
  ];
  int interval = 500;
  AnimationController? _controller;
  int _currentWidget = 0;

  void check_tutorial() async {
    final prefs = await SharedPreferences.getInstance();
    check_tutorial_bool = prefs.get('check_tutorial');
  }

  @override
  initState() {
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
  }

  @override
  void dispose() {
    check_tutorial_bool = null;
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

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var check_tutorial = Provider.of<Http_services>(context).check_tutorial;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                width: size.width * 0.6,
                child: Image(
                  image: AssetImage('assets/images/smartfill_logo.png'),
                  width: 70,
                ),
              ),
              Container(

                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  child: Image.asset(
                    'assets/gifs/main_img.gif',
                  )
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.7,
                  ),
                  check_tutorial != null
                      ? Container()
                      : Container(
                    width: size.width*0.1,
                          child: children[_currentWidget],
                        ),
                ],
              ),
              InkWell(
                  onTap: () async {
                    Sound().play_sound("assets/mp3/start.mp3");
                    //추후 ble scan page로 이동시켜야댐
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: CarNumberPage()));
                  },
                  child: Container(
                      width: size.width * 2,
                      height: size.height * 0.2,
                      child: Image.asset("assets/images/start_button.png"))),
            ]),
          )),
    );
  }
}
