import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/Utils/top_widget.dart';
import 'package:soultec/filling_user/Views/Pages/Fill/FU_fill_finish.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/sound.dart';

class FU_Filling extends StatefulWidget {
  String? litter;

  FU_Filling({required this.litter});

  @override
  _FU_FillingState createState() => _FU_FillingState();
}

class _FU_FillingState extends State<FU_Filling> {
  //노르딕 디바이스 연결
  bool? onTapPressed = false;
  bool fill_start = false;
  bool fill_finish = false;
  var currentValue;

  @override
  initState() {
    super.initState();
    // BLE_CONTROLLER().discoverServices_read(widget.device);
  }

  @override
  void dispose() {
    super.dispose();
    fill_start = false;
    fill_finish = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: WillPopScope(
          onWillPop: () async => false,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Top_widget(),

                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      SizedBox(width: size.width * 0.2),
                      Container(
                        width: size.width * 0.6,
                        height: size.height * 0.08,
                        child: Center(
                            child: Text(
                          "${widget.litter}",
                          style: TextStyle(
                              fontFamily: "numberfont",
                              fontSize: 45,
                              fontWeight: FontWeight.bold),
                        )),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "L",
                          style: TextStyle(
                              fontFamily: "numberfont",
                              fontWeight: FontWeight.bold,
                              fontSize: 46,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),

                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Stack(children: [
                    Center(
                      child: Container(
                          width: size.width * 0.6,
                          child: Image.asset(
                            'assets/images/filling.png',
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 90, left: 130),
                      child: Center(
                        child: Container(
                          width: size.width * 0.3,
                          child: fill_start
                              ? Text('$currentValue',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      fontFamily: "numberfont"))
                              : Text('0.00',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      fontFamily: "numberfont")),
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: size.height * 0.1,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FU_Fill_finish()));
                      Sound().play_sound("assets/mp3/success.mp3");
                    },
                    child: Container(
                        width: size.width * 0.7,
                        height: size.height * 0.1,
                        child: Image.asset("assets/images/play_button.png")),
                  )

                  //snapshot.hasError일때 inkwell 지워준다.

                  //주유가 시작됐을때
                ]),
          ),
        ));
  }
}
