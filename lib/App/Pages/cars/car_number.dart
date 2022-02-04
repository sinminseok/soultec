import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Pages/fills/fill_start.dart';
import 'package:soultec/Data/User/user_object.dart';
import 'package:soultec/Data/toast.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

class CarNumberPage extends StatefulWidget {
  final User? user;
  final Peripheral? peripheral;

  CarNumberPage({required this.user, required this.peripheral});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {
  TextEditingController _carnumber = TextEditingController();


  String url = "http://localhost:8080/carnumber";

  Future post_carnumber() async {
    //url 로 post(이메일 컨트롤러 , 패스워드 컨트롤러)
    var res = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'car-number': _carnumber.text,
        }));
    print(res.body);

    if(res.body == null){
      showAlertDialog(context,"등록된 차량이 아닙니다.","관리자에게 문의하세요");
    }else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Fill_start(
                    user: widget.user, car_number: _carnumber.text,)));
    }
  }


  @override
  void initState() {
    check_connected_fun();
    super.initState();
  }

  void check_connected_fun() async {
    bool check_connected = await widget.peripheral!.isConnected();
    print(check_connected);
  }


  @override
  void dispose(){

  }



  @override
  Widget build(BuildContext context) {
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
                  width: size.width*0.6,
                    child: Image.asset(
                  'assets/gifs/car_number.gif',
                )),
              ),
              SizedBox(height: size.height*0.03,),
              Text(
                "직접 입력",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: "numberfont"),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1
                    ),
                    color: kPrimaryColor),
                child: Center(
                  child: TextFormField(
                    style: TextStyle(fontFamily: "numberfont",fontSize: 21,),
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
                  onTap: (){
                    post_carnumber();

                  },
                  child:Container(
                      width: size.width*0.7,
                      height: size.height*0.1,
                      child: Image.asset("assets/images/play_button.png")
                  )
              ),



              // 페어링된 해당 디바이 스페어링 취소
              InkWell(
                onTap: () async {
                  widget.peripheral!.disconnectOrCancelConnection();
                  print("after disconnectinggg");
                  bool test_check = await widget.peripheral!.isConnected();
                  print(test_check);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text("페어링 취소",
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
              //
              // //디스크 디바이스 초기화
              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();

                   prefs.remove("63:83:A4:59:38:1B");
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text("디스크 초기화",
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
