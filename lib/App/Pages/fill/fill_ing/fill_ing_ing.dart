import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/Bluetooth/ble_controller.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Data/sound.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../../Data/constants.dart';
import '../fill_stop.dart';


//주입기 노즐을 잡아 당길때
class Filling_ing extends StatefulWidget {
  String? liter;
  String? car_number;

  // BluetoothDevice? device;

  Filling_ing({
    required this.car_number,
    required this.liter,
    //   required this.device
  });

  @override
  _Filling_ing createState() => _Filling_ing();
}

class _Filling_ing extends State<Filling_ing> {
  //노르딕 디바이스 연결
  bool? onTapPressed = false;

  @override
  initState() {
    super.initState();
    //BLE_CONTROLLER().discoverServices_read(widget.device);
  }

  @override
  void dispose() {
    super.dispose();
    //BLE_CONTROLLER().disconnect_device(widget.device);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: getBody(size, widget.liter, context),
    );
  }

  getBody(Size size, String? liter, thiscontext) {
    String? user_id = Provider.of<Http_services>(context).user_id;
    String? user_token = Provider.of<Http_services>(context).user_token!.token;

    var currentValue;



    return StreamBuilder<List<int>>(
        stream: BLE_CONTROLLER().stream_value,
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {

          //주입기 노즐이 멈출때
          // if (snapshot.connectionState == "주입기 노즐이 멈출때"){
          //   Navigator.push(
          //       thiscontext,
          //       MaterialPageRoute(
          //           builder: (context) => Filling_stop(car_number: widget.car_number, liter: widget.liter as int)));
          // }
          //주입기이 끝나고 노즐을 제자리에 꽂았을때
          // if (snapshot.connectionState == "주입기 노즐을 꽂았을때"){
          //   Navigator.push(
          //       thiscontext,
          //       MaterialPageRoute(
          //           builder: (context) => Filling_finish(car_number: widget.car_number, liter: widget.liter)));
          // }
            var currentValue;
          //   var currentValue = BLE_CONTROLLER().dataParser(snapshot.data);
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Top_widget(),
                  Text(
                    "${user_id} -- ${widget.car_number}",
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
                          child: Text('${currentValue}',
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

                  //snapshot.hasError일때 inkwell 지워준다.
                  InkWell(
                      onTap: (){
                        showtoast("주유중입니다 잠시만 기다려 주세요");
                      },
                      child: Container(
                          width: size.width * 0.7,
                          height: size.height * 0.1,
                          child: Image.asset("assets/images/stop_button.png"))),
                ]),
          );
        });
  }
}
