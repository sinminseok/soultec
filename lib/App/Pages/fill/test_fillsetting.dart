import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Bluetooth/ble_controller.dart';
import 'package:soultec/App/Bluetooth/blue_scan.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';
import 'fill_ing.dart';

//이제 여기서 블루투스 uuid랑 캐릭터리스틱 가져와서 인코딩 해줘서 해당 디바이스로 데이터를 넘겨준다.
class Test_Fill_Setting extends StatefulWidget {
  // BluetoothDevice? device;
  String? car_number;

  Test_Fill_Setting({
    required this.car_number,
    // required this.device,
  });

  @override
  _Test_Fill_Setting createState() => _Test_Fill_Setting();
}

class _Test_Fill_Setting extends State<Test_Fill_Setting> {
  TextEditingController inputController = TextEditingController();
  List<String> filling_img = ["assets/images/filling/f1.png","assets/images/filling/f2.png","assets/images/filling/f3.png","assets/images/filling/f4.png","assets/images/filling/f5.png","assets/images/filling/f6.png","assets/images/filling/f7.png","assets/images/filling/f8.png","assets/images/filling/f9.png","assets/images/filling/f10.png","assets/images/filling/f11.png"];

  int fill_value = 0;
  String? fill_max;
  double button_position = 360;
  double block_container = 0.3;

  bool? ble_return = null;

  @override
  initState() {
    super.initState();
    inputController;
    button_position;
    //connectToDevice();
  }

  @override
  dispose() {
    ble_return = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? user_id = Provider.of<Http_services>(context).user_id;
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            child: Column(children: [
              Top_widget(),
              // InkWell(child: Text("TEST"),
              // onTap: ()async{
              //   print(widget.device!.state.listen((event) {print(event);}));
              //   // print(widget.device!.state.listen((event) {print(event);}));
              //   // print("GGGGGG");
              // }),
              //right widget
              Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "${user_id} -- ${widget.car_number}",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 29,
                            fontFamily: "numberfont",
                          ),
                        ),
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
                                              fontSize: 40,
                                              fontFamily: "numberfont",
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.3,
                            ),
                            Text(
                              "LITTER",
                              style: TextStyle(
                                  fontFamily: "numberfont",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.red),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                                width: size.width * 0.3,
                                height: size.height * 0.6,
                                child: Image.asset(
                                  'assets/gifs/fill_gif.gif',
                                )),
                            Stack(
                              children: [

                                Container(
                                    height: size.height * 0.6,
                                    child: Image.asset("assets/images/filling_ani.jpeg",width: size.width*0.3,)),
                                Container(
                                  height: size.height*block_container,
                                  width: size.width*0.3,
                                  color: kPrimaryColor,
                                ),
                              ],
                            ),

                            // Container(
                            //   width: size.width * 0.2,
                            //   height: size.height * 0.03,
                            //   child: ListView.builder(
                            //       padding: const EdgeInsets.all(8),
                            //       itemCount: filling_img.length,
                            //       itemBuilder:
                            //           (BuildContext context, int index) {
                            //             return Image.asset(
                            //                 "${filling_img[index]}");
                            //
                            //           }),
                            // )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        InkWell(
                            onTap: () async {
                              Sound().play_sound("assets/mp3/success.mp3");
                              // ble_return = await BLE_CONTROLLER()
                              //     .discoverServices_write(
                              //         null, inputController.text);
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

                              {
                                if (fill_max == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Filling(
                                                car_number: widget.car_number,
                                                liter: fill_value.toString(),
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Filling(
                                                car_number: widget.car_number,
                                                liter: "FULL",
                                              )));
                                }
                              }
                            },
                            child: Container(
                                width: size.width * 0.7,
                                height: size.height * 0.08,
                                child: Image.asset(
                                    "assets/images/play_button.png"))),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.25,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            Sound().play_sound("assets/mp3/click.mp3");
                            setState(() {
                              if (button_position <= -30) {
                                button_position = -30;
                                fill_max = "FULL";
                              } else {
                                block_container = 0.3;
                                fill_max = null;
                                fill_value += 15;
                                button_position -= 30;
                              }
                            });
                          },
                          child: Container(
                              width: size.width * 0.2,
                              child:
                                  Image.asset("assets/images/up_button.png")),
                        ),
                        Container(
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
                                top: button_position,
                                child: Container(
                                    width: size.width * 0.1,
                                    height: size.height * 0.2,
                                    child: Image.asset(
                                        "assets/images/scroll_button.png")),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Sound().play_sound("assets/mp3/click.mp3");
                            setState(() {
                              fill_value -= 15;
                              button_position += 30;
                              setState(() {
                                fill_max = null;
                                if (button_position < 360) {
                                  block_container = 0.2;
                                  fill_value -= 15;
                                  button_position += 30;
                                } else {
                                  block_container = 0.5;
                                  fill_value = 0;
                                  button_position = 360;
                                }
                              });
                            });
                          },
                          child: Container(
                              width: size.width * 0.2,
                              child:
                                  Image.asset("assets/images/down_button.png")),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ]),
          )),
    );
  }
}
