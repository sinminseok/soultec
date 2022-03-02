import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:soultec/App/Bluetooth/ble_write.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';
import 'fill_ing.dart';
import 'dart:convert' show utf8;

//이제 여기서 블루투스 uuid랑 캐릭터리스틱 가져와서 인코딩 해줘서 해당 디바이스로 데이터를 넘겨준다.
class Fill_setting extends StatefulWidget {
  User_token? user_token;
  User? user_info;
  String? user_id;
  String car_number;
  BluetoothDevice? device;

  Fill_setting(
      {required this.user_token,
      required this.user_id,
      required this.car_number,
      required this.device,
        required this.user_info,
      });

  @override
  _Fill_setting createState() => _Fill_setting();
}

class _Fill_setting extends State<Fill_setting> {
  int pageIndex = 0;
  TextEditingController inputController = TextEditingController();
  @override
  initState() {
    super.initState();
    connectToDevice();
  }

  //
  final values = ["가득", "리터"];
  String? _select_value;

  //init에 넣어준뒤 페어링시도
  String? connectionText = "";
  BluetoothCharacteristic? targetCharacteristic;

  connectToDevice() async {
    if (widget.device == null) return;
    setState(() {
      connectionText = "Device Connecting";
    });
    await widget.device!.connect();
    print('DEVICE CONNECTED');
    setState(() {
      connectionText = "Device Connected";
    });
  }


  //해당 디바이스의 보낼 서비스 uuid를 를아 데이터 송신하는 함수


  //넘겨줄 string 데이터를 utf8로 인코딩 해서 송신하는 함수
  // writeData(String data) async {
  //   if (targetCharacteristic == null) return;
  //
  //   List<int> bytes = utf8.encode(data);
  //   await targetCharacteristic!.write(bytes);
  // }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: SingleChildScrollView(
              child: Column(children: [
                Top_widget(),
                //
                Text(
                  "${widget.user_id} - ${widget.car_number}",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 29,
                    fontFamily: "numberfont",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                      width: size.width * 0.8,
                      height: size.height * 0.4,
                      child: Image.asset(
                        'assets/gifs/main_img.gif',
                      )),
                ),
                Container(
                  width: size.width * 0.6,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: kPrimaryColor),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "numberfont",
                      fontSize: 29,
                    ),
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: '리터량 입력',
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton(
                      elevation: 17,
                      underline: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.black))),
                      hint: Text(
                        "가득/리터",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      value: _select_value,
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (val) => setState(() => {
                      Sound().play_sound("assets/mp3/success.mp3"),
                            _select_value = val.toString(),
                            if (val.toString() == "가득")
                              {inputController.text = "∞"}
                            else
                              {inputController.text = ""}
                          }),
                      items: [
                        for (var val in values)
                          DropdownMenuItem(
                            value: val,
                            child: SizedBox(
                              child: Text(
                                val.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: size.width * 0.2),
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
                SizedBox(
                  height: size.height * 0.06,
                ),
                InkWell(
                    onTap: () async {
                      User? user =await Http_services().get_user_info(widget.user_id, widget.user_token!.token);
                      if (_select_value == null) {
                        if (!inputController.text.isEmpty) {
                          Sound().play_sound("assets/mp3/success.mp3");
                          // BLE_CONTROLLER().discoverServices_write(widget.device,);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Filling(
                                      user_info :user,
                                      user_token: widget.user_token,
                                      user_id: widget.user_id,
                                      liter: int.parse('${inputController.text}') ,
                                      car_number: widget.car_number,
                                      device:widget.device,

                        )));
                        } else {
                          Sound().play_sound("assets/mp3/error.mp3");
                          showtoast("리터량을 설정해주세요!");
                        }
                      } else if (_select_value == "가득") {
                        Sound().play_sound("assets/mp3/success.mp3");
                       // BLE_CONTROLLER().discoverServices_write(widget.device);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Filling(
                                  user_info :user,
                                  user_token: widget.user_token,
                                    user_id: widget.user_id,
                                    liter: 100,
                                    car_number: widget.car_number, device: widget.device,

                              )));
                      } else if (_select_value == "리터") {
                        if (!inputController.text.isEmpty) {
                          Sound().play_sound("assets/mp3/success.mp3");
                          //BLE_CONTROLLER().discoverServices_write(widget.device);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Filling(
                                    user_info :user,
                                    user_token: widget.user_token,
                                      user_id: widget.user_id,
                                      liter: int.parse('${inputController.text}'),
                                      car_number: widget.car_number,
                                    device: widget.device,
                              )));
                        } else {
                          Sound().play_sound("assets/mp3/error.mp3");
                          return showtoast("리터량을 설정해주세요!");
                        }
                      }
                    },
                    child: Container(
                        width: size.width * 0.7,
                        height: size.height * 0.1,
                        child: Image.asset("assets/images/play_button.png"))),
              ]),
            )
      ),
    );
  }

  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
