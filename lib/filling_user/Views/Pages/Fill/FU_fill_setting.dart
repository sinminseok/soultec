import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Utils/top_widget.dart';

import '../../../../Utils/constants.dart';
import '../../../../Utils/sound.dart';
import '../../../../Utils/toast.dart';
import '../../../../nomal_user/Presenter/data_controller.dart';
import 'FU_filling.dart';

class FU_Fill_Setting extends StatefulWidget {
  Size sizee;
  String? qr_info;
  FU_Fill_Setting({required this.sizee,required this.qr_info});

  @override
  _FU_Fill_SettingState createState() => _FU_Fill_SettingState();
}

class _FU_Fill_SettingState extends State<FU_Fill_Setting> with SingleTickerProviderStateMixin {
  var check_tutorial_bool;

  List<Widget> children = [
    Image.asset(
      "assets/images/arrow.png",
    ),
    Image.asset(
      "assets/images/arrow.png",
      color: Colors.transparent,
    ),
  ];
  int interval = 500;

  AnimationController? _controller;
  int _currentWidget = 0;

  void check_tutorial() async {
    final prefs = await SharedPreferences.getInstance();
    check_tutorial_bool = prefs.get('check_tutorial');
  }

  Offset? offset;
  int fill_value = 0;
  String? fill_max = null;
  double button_position = 360;
  double block_container = 0.5;
  bool? ble_return = null;
  Stream<String>? device_number_stream;
  var device_number;

//해당 주유기 번호
//  var device_numberl;
  @override
  initState() {
    //주유 정보 가져오기
    // device_number = BLE_CONTROLLER().read_device_information(widget.device);


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
    offset = Offset(0, widget.sizee.height * 0.47);
    super.initState();

  }

  @override
  dispose() {
    check_tutorial_bool = null;
    button_position = 360;
    block_container = 0.5;
    fill_max = null;
    fill_value = 0;
    ble_return = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var check_tutorial = Provider.of<Http_services>(context).check_tutorial;
    String? user_id = Provider.of<Http_services>(context).user_id;
    Size size = MediaQuery.of(context).size;
    var offsetoffset = offset;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(children: [
          Top_widget(),
          Text("${widget.qr_info}"),
          Row(
            children: [
              Container(
                child: Column(
                  children: [

                    Row(
                      children: [
                        fill_max == null
                            ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1),
                                color: kPrimaryColor),
                            child: Center(
                                child: Text("$fill_value",
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontFamily: "numberfont",
                                        fontWeight: FontWeight.bold))),
                          ),
                        )
                            : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1),
                                color: kPrimaryColor),
                            child: Center(
                                child: Text("$fill_max",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: "numberfont",
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "L",
                            style: TextStyle(
                                fontFamily: "numberfont",
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Container(
                      width: size.width * 0.6,
                      height: size.height * 0.5,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.21,
                              ),
                              Container(
                                  width: size.width * 0.23,
                                  height: size.height * 0.29,
                                  child: Image.asset(
                                    'assets/gifs/fill_gif.gif',
                                  )),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                  height: size.height * 0.7,
                                  width: size.width * 0.37,
                                  child: Image.asset(
                                    "assets/images/Gage.png",
                                    width: size.width * 0.3,
                                  )),
                              Container(
                                width: size.width * 0.37,
                                height: size.height * block_container,
                                color: kPrimaryColor,
                              ),
                              // check_tutorial != null
                              //     ? Container()
                              //     : Positioned(
                              //         top: size.height * 0.4,
                              //         left: size.width * 0.2,
                              //         child: Container(
                              //           width: size.width * 0.1,
                              //           child: children[_currentWidget],
                              //         ),
                              //       ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    InkWell(
                        onTap: () async {
                          //주유 시작 신호 넘기기
                          Sound().play_sound("assets/mp3/success.mp3");
                          if (fill_value == 0) {
                            return showtoast("리터량을 설정해주세요");
                          }
                          if (fill_max == null) {
                            // ble_return = await BLE_CONTROLLER()
                            //     .ble_post_litter(
                            //         widget.device, fill_value);
                            // if (ble_return == false) {
                            //   final prefs =
                            //       await SharedPreferences.getInstance();
                            //   prefs.remove('${widget.device!.id}');
                            //
                            // showtoast("해당 블루투스는 주유기가 아닙니다.주유기로 다시한번 페어링 해주세요");
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => Blue_scan()));
                            // } else
                            print("gdf");
                            print("${fill_value.toString().runtimeType}");
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: FU_Filling(litter: fill_value.toString(),

                                    )));
                          } else {
                            // ble_return = await BLE_CONTROLLER()
                            //     .discoverServices_write(
                            //         null, "가득");
                            // if (ble_return == false) {
                            //   final prefs =
                            //       await SharedPreferences.getInstance();
                            //   prefs.remove('${widget.device!.id}');
                            //
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => Blue_scan()));
                            // } else

                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: FU_Filling(litter: "FULL",

                                    )));
                          }
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.08,
                            child:
                            Image.asset("assets/images/play_button.png"))),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.3,
                child: Column(
                  children: [
                    //up
                    InkWell(
                      onTap: () async {
                        Sound().play_sound("assets/mp3/click.mp3");
                        setState(() {
                          if (offset!.dy <= size.height * -0.035) {
                            offset = Offset(offset!.dx + size.width * 0.1,
                                size.height * -0.035);
                            fill_max = "FULL";
                          } else {
                            if (block_container >= 0.1) {
                              block_container -= 0.021;
                            }
                            fill_max = null;
                            fill_value += 1250;
                            offset = Offset(offset!.dx + size.width * 0.1,
                                offset!.dy - size.height * 0.026);
                          }
                        });
                      },
                      child: Container(
                          width: size.width * 0.2,
                          child: Image.asset("assets/images/up_button.png")),
                    ),

                    Row(
                      children: [
                        check_tutorial != null
                            ? Container(
                          width: size.width * 0.1,
                        )
                            : Container(
                            height: size.height * 0.15,
                            width: size.width * 0.1,
                            child: Image.asset(
                              "assets/gifs/updown.gif",
                              width: size.width * 0.3,
                            )),
                        Container(
                          height: size.height * 0.63,
                          width: size.width * 0.1,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  width: size.width * 0.01,
                                  height: size.height * 0.6,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black),
                                ),
                              ),
                              Positioned(
                                top: offsetoffset!.dy,
                                child: GestureDetector(
                                  child: Container(
                                    width: size.width * 0.1,
                                    height: size.height * 0.2,
                                    child: Image.asset(
                                        "assets/images/scroll_button.png"),
                                  ),
                                  onPanUpdate: (details) {
                                    setState(() {
                                      offset = Offset(
                                          offset!.dx + details.delta.dx,
                                          offset!.dy + details.delta.dy);

                                      if (offset!.dy + details.delta.dy >
                                          size.height * 0.467) {
                                        if (offset!.dy + details.delta.dy ==
                                            343.3182142857142) {
                                          Sound().play_sound(
                                              "assets/mp3/click.mp3");
                                        }

                                        offset = Offset(
                                            offset!.dx + details.delta.dx,
                                            size.height * 0.467);
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.45) {
                                        setState(() {
                                          fill_value = 0;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.428) {
                                        print(offset!.dy + details.delta.dy);

                                        setState(() {
                                          fill_value = 1250;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.402) {
                                        print(offset!.dy + details.delta.dy);
                                        if (offset!.dy + details.delta.dy ==
                                            278.1619642857131) {
                                          Sound().play_sound(
                                              "assets/mp3/click.mp3");
                                        }
                                        setState(() {
                                          fill_value = 2500;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.376) {
                                        setState(() {
                                          fill_value = 3750;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.35) {
                                        setState(() {
                                          block_container = 0.42099999999999993;
                                          fill_value = 5000;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.324) {
                                        setState(() {
                                          block_container = 0.3999999999999999;
                                          fill_value = 6250;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.298) {
                                        setState(() {
                                          block_container = 0.3789999999999999;
                                          fill_value = 7500;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.272) {
                                        setState(() {
                                          block_container = 0.3579999999999999;
                                          fill_value = 8750;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.246) {
                                        setState(() {
                                          block_container = 0.33699999999999986;
                                          fill_value = 10000;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.22) {
                                        setState(() {
                                          block_container = 0.31599999999999984;
                                          fill_value = 11250;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.194) {
                                        setState(() {
                                          block_container = 0.2949999999999998;
                                          fill_value = 12500;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.168) {
                                        setState(() {
                                          block_container = 0.2739999999999998;
                                          fill_value = 13750;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.142) {
                                        setState(() {
                                          block_container = 0.2529999999999998;
                                          fill_value = 15000;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.116) {
                                        setState(() {
                                          block_container = 0.2319999999999998;
                                          fill_value = 16250;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.09) {
                                        setState(() {
                                          block_container = 0.2109999999999998;
                                          fill_value = 17500;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.064) {
                                        setState(() {
                                          block_container = 0.1899999999999998;
                                          fill_value = 18750;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.038) {
                                        setState(() {
                                          block_container = 0.16899999999999982;
                                          fill_value = 20000;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * 0.012) {
                                        setState(() {
                                          block_container = 0.14799999999999983;
                                          fill_value = 21250;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * -0.014) {
                                        setState(() {
                                          block_container = 0.12699999999999984;
                                          fill_value = 22500;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <
                                          size.height * -0.04) {
                                        setState(() {
                                          block_container = 0.10599999999999983;
                                          fill_max = null;
                                          fill_value = 23750;
                                        });
                                      }
                                      if (offset!.dy + details.delta.dy <=
                                          size.height * -0.066) {
                                        setState(() {
                                          offset = Offset(
                                              offset!.dx + details.delta.dx,
                                              size.height * -0.066);
                                          fill_max = "Full";
                                          block_container = 0.08499999999999983;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //down
                    InkWell(
                      onTap: () {
                        Sound().play_sound("assets/mp3/click.mp3");

                        setState(() {
                          if (block_container <= 0.5) {
                            block_container += 0.019;
                          }
                          fill_max = null;
                          if (offset!.dy < size.height * 0.45) {
                            fill_value -= 1250;
                            offset = Offset(offset!.dx + size.width * 0.1,
                                offset!.dy + size.height * 0.03);
                          } else {
                            fill_value = 0;
                            button_position = 360;
                          }
                        });
                      },
                      child: Container(
                          width: size.width * 0.2,
                          child: Image.asset("assets/images/down_button.png")),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
