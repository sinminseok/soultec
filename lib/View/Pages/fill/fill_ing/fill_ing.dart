import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/Presenter/ble_presenter.dart';
import 'package:soultec/View/Pages/fill/fill_ing/fill_ing_stop.dart';
import 'package:soultec/View/Pages/receipt/receipt_list.dart';
import 'package:soultec/Utils/top_widget.dart';
import 'package:soultec/Presenter/data_controller.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/sound.dart';
import '../../../../Utils/toast.dart';

class Filling extends StatefulWidget {

  String? liter;
  String? car_number;

  BluetoothDevice? device;

  Filling({
    required this.car_number,
    required this.liter,
      required this.device
  });

  @override
  _Filling createState() => _Filling();
}

class _Filling extends State<Filling> {
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
      body: getBody(size, widget.liter, context),
    );
  }

  getBody(Size size, String? liter, thiscontext) {
    String? user_id = Provider.of<Http_services>(context).user_id;
    String? user_token = Provider.of<Http_services>(context).user_token!.token;

    return StreamBuilder<List<int>>(
        stream: BLE_CONTROLLER().device_number_stream,
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {

          if (snapshot.connectionState == ConnectionState.active) {
            setState(() {

              currentValue = BLE_CONTROLLER().dataParser(snapshot.data);
              fill_start = true;
            });
          }

          //노즐이 멈출때
          if (snapshot.data == "노즐 스탑") {
            Navigator.push(
                thiscontext,
                MaterialPageRoute(
                    builder: (context) => Filling_stop(
                        car_number: widget.car_number, liter: currentValue as String)));
          }

          if (snapshot.data == "주입 종료") {
            setState(() {
              fill_finish = true;
            });
          }

          return WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
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
                    Row(
                      children: [
                        SizedBox(width: size.width*0.2),
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

                    //snapshot.hasError일때 inkwell 지워준다.

                    //주유가 시작됐을때
                    fill_start
                        ? fill_finish
                        ? InkWell(
                        onTap: onTapPressed == true
                            ? null
                            : () async {
                          setState(() {
                            onTapPressed = true;
                          });
                          Sound()
                              .play_sound("assets/mp3/success.mp3");
                          //주석 제거 (해당 receipt 정보 서버로post)
                          // post_receipt(username, pumpId, branchId, amount, carNumber, token)

                          //post_receipt는 주유기 시리얼 넘버로 어디 지점인지 알려준다. 추후 하드웨어와 협상후 시리얼 번호를 등록한다.
                          var res = await Http_services()
                              .post_receipt(
                            //등록된 pumpid 입력
                              "12341234",
                              widget.liter,
                              widget.car_number,
                              user_token);
                          // 주유후 해당 디바이스  페어링 disconnect
                          //   widget.device!.disconnect();

                          if (res != null) {
                            var data_list = await Http_services()
                                .load_receipt_list(user_token);

                            Navigator.push(
                                thiscontext,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Receipt_list(
                                            car_number:
                                            widget.car_number,
                                            data_list: data_list)));

                            showtoast("주유가 완료 되었습니다!");
                          } else {
                            showtoast("주유 정보 등록이 실패했습니다.");
                          }
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child: Image.asset(
                                "assets/images/stop_box.png")))
                        : InkWell(
                        onTap: () {
                          showtoast("주유중입니다 잠시만 기다려주세요");
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child: Image.asset(
                                "assets/images/stop_button.png")))
                        : InkWell(

                      //추후 ontap에 있는 기능 빼야됨
                        onTap: onTapPressed == true
                            ? null
                            : () async {
                          setState(() {
                            onTapPressed = true;
                          });
                          Sound().play_sound("assets/mp3/success.mp3");
                          //주석 제거 (해당 receipt 정보 서버로post)
                          // post_receipt(username, pumpId, branchId, amount, carNumber, token)

                          //post_receipt는 주유기 시리얼 넘버로 어디 지점인지 알려준다. 추후 하드웨어와 협상후 시리얼 번호를 등록한다.
                          var res = await Http_services().post_receipt(
                              "12341234",
                              widget.liter,
                              widget.car_number,
                              user_token);
                          // 주유후 해당 디바이스  페어링 disconnect
                          //   widget.device!.disconnect();

                          if (res != null) {
                            var data_list = await Http_services()
                                .load_receipt_list(user_token);

                            Navigator.push(
                                thiscontext,
                                MaterialPageRoute(
                                    builder: (context) => Receipt_list(
                                        car_number: widget.car_number,
                                        data_list: data_list)));
                            showtoast("주유가 완료 되었습니다!");
                          } else {
                            showtoast("주유 정보 등록이 실패했습니다.");
                          }
                        },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child: Image.asset(
                                "assets/images/play_button.png"))),
                  ]),
            ),
          );
        });
  }
}