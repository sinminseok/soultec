import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Pages/fills/fill_start.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';

class CarNumberPage extends StatefulWidget {
  final User_token? user_token;
  String? user_id;
  BluetoothDevice? device;


  CarNumberPage({required this.user_token,required this.user_id, required this.device});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {
  TextEditingController? _carnumber = TextEditingController();
  bool check_connected = false;

  @override
  void initState() {
    remember_device(widget.device!.id);
    call();
    super.initState();
  }

  Future<void> call()async{
    await widget.device!.connect();
  }

  @override
  void dispose(){
    super.dispose();
    _carnumber =null;
  }


  //ble device 기기 id값을 디스크에 저장 추후 자동 페어링 할때 사용
  void remember_device(device_id)async{
    String? check_device_id = device_id.toString();
// shared preferences 얻기
    final prefs = await SharedPreferences.getInstance();
// 값 저장하기
    prefs.setString('$check_device_id',check_device_id);
    return;
  }


  @override
  Widget build(BuildContext context) {
    var user_token= widget.user_token!.token;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                  InkWell(
                    onTap: ()async{
                      await call();
                    },
                    child: Text("TEET"),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: size.width * 0.6,
                    child: Image.asset(
                      'assets/gifs/car_number.gif',
                    )),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "직접 입력",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "numberfont"),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    color: kPrimaryColor),
                child: Center(
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "numberfont",
                      fontSize: 21,
                    ),
                    controller: _carnumber,
                    decoration: InputDecoration(
                      hintText: '차량번호 4 자리 입력',
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.001,
              ),
              Center(
                child: Text(
                  "확인을 누르면 조회를 시작합니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "numberfont",
                      color: Colors.red.shade300,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),

              InkWell(
                  onTap: () async{
                    //http get car_number return bool
                    var return_carnumber =await Http_services().post_carnumber(_carnumber!.text,user_token);

                    if(return_carnumber == true){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Fill_start(
                                      user_token: widget.user_token ,user_id:widget.user_id,car_number: _carnumber!.text,device:widget.device)));

                    }else{
                      showtoast("등록되지 않은 차번호 입니다.");
                    }

                  },
                  child: Container(
                      width: size.width * 0.7,
                      height: size.height * 0.1,
                      child: Image.asset("assets/images/play_button.png"))),

            ],
          ),
        ),
      ),
    );
  }
}
