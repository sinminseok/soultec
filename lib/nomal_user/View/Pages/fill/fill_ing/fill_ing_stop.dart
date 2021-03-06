import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/Utils/constants.dart';
import '../../../../../Utils/sound.dart';
import '../../../../../Utils/toast.dart';
import '../../../../../Utils/top_widget.dart';
import '../../../../Presenter/ble_presenter.dart';
import '../../../../Presenter/data_controller.dart';
import '../../receipt/receipt_list.dart';

//주입기 노즐이 멈췄을때 회면
class Filling_stop extends StatefulWidget {
  String? liter;
  String? car_number;

  // BluetoothDevice? device;

  Filling_stop({
    required this.car_number,
    required this.liter,
    //   required this.device
  });

  @override
  _Filling_stop createState() => _Filling_stop();
}

class _Filling_stop extends State<Filling_stop> {
  //노르딕 디바이스 연결
  bool? onTapPressed = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<List<int>>(
          stream: BLE_CONTROLLER().device_number_stream,
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
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
                        onTap: onTapPressed == true
                            ? null
                            : () async {
                                setState(() {
                                  onTapPressed = true;
                                });
                                Sound().play_sound("assets/mp3/success.mp3");
                                //주석 제거 (해당 receipt 정보 서버로post)
                                // post_receipt(username, pumpId, branchId, amount, carNumber, token)
                                var res = await Http_services().post_receipt(
                                    "12341234",
                                    widget.liter,
                                    widget.car_number,
                                    user_token);
                                // 주유후 해당 디바이스  페어링 disconnect
                                //   widget.device!.disconnect();

                                // if (res != null) {
                                var data_list = await Http_services()
                                    .load_receipt_list(user_token);
                                Navigator.push(
                                    thiscontext,
                                    MaterialPageRoute(
                                        builder: (context) => Receipt_list(
                                            car_number: widget.car_number,
                                            data_list: data_list)));

                                showtoast("주유가 완료 되었습니다!");
                                // } else {
                                //   showtoast("주유 정보 등록이 실패했습니다.");
                                // }
                              },
                        child: Container(
                            width: size.width * 0.7,
                            height: size.height * 0.1,
                            child: Image.asset(
                                "assets/images/fill_ing_stop.png"))),
                  ]),
            );
          }),
    );
  }
}
