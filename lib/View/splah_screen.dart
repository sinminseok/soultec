import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:soultec/Utils/constants.dart';

import 'Account/login_page.dart';

class Splah_Screen extends StatefulWidget {
  const Splah_Screen({Key? key}) : super(key: key);

  @override
  _Splah_ScreenState createState() => _Splah_ScreenState();
}

class _Splah_ScreenState extends State<Splah_Screen> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 3000), () {
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: new Scaffold(
          backgroundColor: kPrimaryColor,
          body: new Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.3),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30.0,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('충전관리 솔루션 스마트 필',
                          textStyle: TextStyle(
                              color: Colors.black, fontFamily: "fonttext"))
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
                Container(
                    width: size.width * 0.8,
                    child: Image.asset(
                      'assets/gifs/main_img.gif',
                    )),
                Expanded(child: SizedBox()),
                Align(
                  child: Text("© CREATE 2022, 스마트 필(SMTF)",
                      style: TextStyle(
                        fontSize: screenWidth * (14 / 360),
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0625,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
