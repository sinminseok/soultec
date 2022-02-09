import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:soultec/App/Pages/receipt/receipt.dart';
import 'package:soultec/Data/User/user_object.dart';
import '../../../constants.dart';


class Filling extends StatefulWidget {
  final String? liter;
  final String? car_number;
  final User? user;
  final Peripheral? peripheral;

  Filling({required this.user, required this.liter,required this.car_number ,required this.peripheral});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  String BLE_SERVICE_UUID = "";
  String BLE_TX_CHARACTERISTIC="";

  Stream<int>? stream;

  StreamSubscription? monitoringStreamSubscription;

  post_ble(peripheral,LITTER)async{
    //보낼때
//받는 캐리터리스틱 모니터링 ON 함수, 보통 Notification Enable 정도로 생각하면될 것 같다.
    var characteristicUpdates = peripheral.monitorCharacteristic(
        BLE_SERVICE_UUID,
        BLE_TX_CHARACTERISTIC);

//데이터 받는 리스너 핸들 변수


//이미 리스너가 있다면 취소
    await monitoringStreamSubscription!.cancel(); // ?. = 해당객체가 null이면 무시하고 넘어감.

    stream = characteristicUpdates.listen((value) {
    print("read data : ${value.value}");  //데이터 출력
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
    Peripheral? peripheral = widget.peripheral;
    var liter = v;
    return SafeArea(
      child: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
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
                    "0123-45gj6789",
                    style: TextStyle(
                        color: Colors.red, fontSize: 29, fontFamily: "numberfont"),
                  ),
                  SizedBox(height: size.height*0.02,),
                  Container(
                    width: size.width*0.6,
                    height: size.height*0.08,
                    child: Center(child: Text("$liter" , style: TextStyle(fontFamily: "numberfont",fontSize: 45 , fontWeight: FontWeight.bold),)),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: size.height*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(width: size.width * 0.4),
                      Text("LITTER",style: TextStyle(fontFamily: "numberfont",fontWeight: FontWeight.bold,fontSize: 24,color: Colors.red),),

                    ],
                  ),
                  SizedBox(height: size.height*0.4,),
                  //Text(liter),

                  InkWell(
                    onTap: () {
                      //data push
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Recepit(
                                  user: widget.user,
                                  liter: widget.liter , car_number: widget.car_number)));
                    },
                      child:Container(
                      width: size.width*0.7,
                      height: size.height*0.1,
                      child: Image.asset("assets/images/play_button.png")
                  )
                  ),
                ]),
          );
        }
      ),
    );
  }
}
