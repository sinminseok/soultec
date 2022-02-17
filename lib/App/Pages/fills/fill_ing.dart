import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:soultec/App/Pages/receipt/receipt.dart';
import 'package:soultec/Data/Object/user_object.dart';
import '../../../constants.dart';

class Filling extends StatefulWidget {
  final String? liter;
  String? user_id;
  final String? car_number;
  final User? user;
  final Peripheral? peripheral;

  Filling(
      {required this.user,
        required this.user_id,
      required this.liter,
      required this.car_number,
      required this.peripheral});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  //노르딕 디바이스 연결


  @override
  initState() {
    super.initState();
    get_ble(widget.peripheral, widget.liter);
  }

  //Stream 오브젴 생성 추후 전달 받은 데이터 이동 통로가 될 것이당.!
  Stream? characteristicUpdates;


  get_ble(peripheral, litter) async {
    //리터값이 가득일떄랑 선택한 리터값 각각의 보내는 데이터 필터링 해주는 코드 작성해야함ㅋ
    //보낼때
    //해당 서비스, 캐릭터 리스틱 uuid 와 연결해 데이터를 받아오는 var 생성 여

    //monitorCharacteristic 의 리턴 타입이 Stream 이다
    characteristicUpdates = peripheral.monitorCharacteristic(
        BLE_SERVICE_UUID, BLE_RX_CHARACTERISTIC);

    characteristicUpdates!.listen(
          (value){
            print("read data : ${value.value}");
            },
      onError: (error) {
        print("Error while monitoring characteristic \n$error"); //실패시
      },
      cancelOnError: true, //에러 발생시 자동으로 listen 취소
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor, body: getBody(size, widget.liter));
  }

  getBody(Size size, String? v) {
    var liter = v;
    return SafeArea(
      child: StreamBuilder(
          stream: characteristicUpdates,
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
                      "${widget.user_id} --${widget.car_number}",
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
                        onTap: () {
                          //data push
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Recepit(
                                      user: widget.user,
                                      user_id:widget.user_id,
                                      liter: widget.liter,
                                      car_number: widget.car_number)));
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
