import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:soultec/App/Pages/receipt/receipt.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';

class Filling extends StatefulWidget {
  User? user_info;
  String? user_id;
  final String? car_number;
  final int? liter;
  final User_token? user_token;
  BluetoothDevice? device;

  Filling(
      {required this.user_info,
      required this.user_token,
      required this.user_id,
      required this.liter,
      required this.car_number,
      required this.device});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  //노르딕 디바이스 연결
  bool? isReady = false;
  Stream? stream;

  @override
  initState() {
    super.initState();
  }


  discoverServices() async {
    if (widget.device == null) {
      return;
    }

    List<BluetoothService> services = await widget.device!.discoverServices();

    services.forEach((service) {
      if (service.uuid.toString() == GET_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == GET_CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;
            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady!) {
      _Pop();
    }
  }


  _Pop() {
    Navigator.of(context).pop(true);
  }

  //데이터 utf8로 파싱후 ui로 보여준다.
  String _dataParser(List<int>? dataFromDevice) {
    return utf8.decode(dataFromDevice!);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor, body: getBody(size, widget.liter));
  }

  getBody(Size size, int? liter) {
    return SafeArea(
      child: StreamBuilder(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //if(snapshot.hasError)
            return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "충전관리 솔루션",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "스마트필",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Image(
                            image: AssetImage('assets/images/mainimg.png'),
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      "${widget.user_id} -- ${widget.car_number}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 29,
                        fontFamily: "numberfont",
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: size.width * 0.6,
                      height: size.height * 0.08,
                      child: Center(
                          child: Text(
                        "$liter",
                        style: TextStyle(
                            fontFamily: "numberfont",
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      )),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: size.width * 0.4),
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
                      height: size.height * 0.07,
                    ),
                    Container(
                        width: size.width * 0.6,
                        child: Image.asset(
                          'assets/gifs/load2.GIF',
                        )),
                    SizedBox(
                      height: size.height * 0.15,
                    ),
                    //Text(liter),

                    InkWell(
                        onTap: () async{
                          //주석 제거 (해당 receipt 정보 서버로post)
                         //await Http_services().post_receipt(widget.user_id.toString() , 4 , 5 , 28 ,widget.car_number.toString() , widget.user_token!.token);


                          //주유후 해당 디바이스 페어링 disconnect
                          widget.device!.disconnect();

                          var data_list = await Http_services().load_receipt_list(widget.user_token!.token);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Receipt_list(
                                      user: widget.user_token,
                                      user_id: widget.user_id,
                                      car_number: widget.car_number, data_list:data_list,)));
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child:
                                Image.asset("assets/images/play_button.png"))),
                  ]),
            );
            //if(if (snapshot.connectionState == ConnectionState.active)
          }),
    );
  }
}
