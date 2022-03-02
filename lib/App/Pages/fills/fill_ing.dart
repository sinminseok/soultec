import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:soultec/App/Bluetooth/ble_write.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
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

  @override
  initState() {
    super.initState();
    //BLE_CONTROLLER().discoverServices_read(widget.device);
  }

  //stream으로 받은 데이터 리스트 저장후 마지막 리턴값이 최종 주유량 이후 dispose()에서 초기화후 메모리 공간 확보
  List<int> traceDust = [];

  @override
  void dispose(){
    super.dispose();
    traceDust = [];
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor, body: getBody(size, widget.liter,context),);
  }

  getBody(Size size, int? liter,thiscontext) {
    return StreamBuilder(
          stream: BLE_CONTROLLER().stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //if(snapshot.hasError)
            return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Top_widget(),
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

                    InkWell(
                        onTap: () async{
                          Sound().play_sound("assets/mp3/success.mp3");
                          //주석 제거 (해당 receipt 정보 서버로post)
                          // await Http_services().post_receipt(widget.user_id.toString() , 4 , 5 , 28 ,widget.car_number.toString() , widget.user_token!.token);

                          // 주유후 해당 디바이스  페어링 disconnect
                          widget.device!.disconnect();

                          var data_list = await Http_services().load_receipt_list(widget.user_token!.token);

                          Navigator.push(
                              thiscontext,
                              MaterialPageRoute(
                                  builder: (context) => Receipt_list(
                                      user: widget.user_token,
                                      user_id: widget.user_id,
                                      car_number: widget.car_number, data_list:data_list)));

                          showtoast("주유가 완료 되었습니다!");
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child:
                            Image.asset("assets/images/play_button.png"))),

                  ]),
            );

            // if(snapshot.connectionState == ConnectionState.active){
            //   var currentValue = BLE_CONTROLLER().dataParser(snapshot.data);
            //   traceDust.add(currentValue);
            //   SingleChildScrollView(
            //     child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Top_widget(),
            //           Text(
            //             "${widget.user_id} -- ${widget.car_number}",
            //             style: TextStyle(
            //               color: Colors.red,
            //               fontSize: 29,
            //               fontFamily: "numberfont",
            //             ),
            //           ),
            //
            //           SizedBox(
            //             height: size.height * 0.02,
            //           ),
            //           Container(
            //             width: size.width * 0.6,
            //             height: size.height * 0.08,
            //             child: Center(
            //                 child: Text(
            //                   "$liter",
            //                   style: TextStyle(
            //                       fontFamily: "numberfont",
            //                       fontSize: 45,
            //                       fontWeight: FontWeight.bold),
            //                 )),
            //             decoration: BoxDecoration(
            //               border: Border.all(color: Colors.black),
            //             ),
            //           ),
            //           SizedBox(
            //             height: size.height * 0.02,
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SizedBox(width: size.width * 0.4),
            //               Text(
            //                 "LITTER",
            //                 style: TextStyle(
            //                     fontFamily: "numberfont",
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 24,
            //                     color: Colors.red),
            //               ),
            //             ],
            //           ),
            //
            //           SizedBox(
            //             height: size.height * 0.07,
            //           ),
            //
            //           Container(
            //             width: size.width * 0.6,
            //             child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   Text('Current value from Sensor',
            //                       style: TextStyle(fontSize: 14)),
            //                   Text('${currentValue} LITTER',
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 40,fontFamily: "numberfont"))
            //                 ]),),
            //
            //           SizedBox(
            //             height: size.height * 0.15,
            //           ),
            //
            //           InkWell(
            //               onTap: () async{
            //                 //주석 제거 (해당 receipt 정보 서버로post)
            //                 // await Http_services().post_receipt(widget.user_id.toString() , 4 , 5 , 28 ,widget.car_number.toString() , widget.user_token!.token);
            //
            //                 // 주유후 해당 디바이스  페어링 disconnect
            //                 widget.device!.disconnect();
            //
            //                 var data_list = await Http_services().load_receipt_list(widget.user_token!.token);
            //
            //                 Navigator.push(
            //                     thiscontext,
            //                     MaterialPageRoute(
            //                         builder: (context) => Receipt_list(
            //                             user: widget.user_token,
            //                             user_id: widget.user_id,
            //                             car_number: widget.car_number, data_list:data_list)));
            //
            //                 showtoast("주유가 완료 되었습니다!");
            //               },
            //               child: Container(
            //                   width: size.width * 0.7,
            //                   height: size.height * 0.1,
            //                   child:
            //                   Image.asset("assets/images/play_button.png"))),
            //
            //         ]),
            //   );
            // }

          }
    );
  }
}
