import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../fills/fill_start.dart';


class CarNumberPage extends StatefulWidget {
  final String? uid;
  final Peripheral? peripheral;

  CarNumberPage({required this.uid, required this.peripheral});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {
  TextEditingController _carnumber = TextEditingController();


  @override
  void initState() {

    check_connected_fun();
    super.initState();
  }

  void check_connected_fun() async {
    bool check_connected = await widget.peripheral!.isConnected();
    print("minseopkdkasdbhjk");
    print(check_connected);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var test = widget.peripheral;
    var test_i = widget.peripheral!.identifier;

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
              Text(
                "직접 입력",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: "numberfont"),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                child: TextFormField(
                  controller: _carnumber,
                  decoration: InputDecoration(
                      hintText: '차량 번호 4자리 입력', border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
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
                height: size.height * 0.05,
              ),
              InkWell(
                onTap: () async {
                  //추후 차량 번호http 인증 해야댐

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home_page(
                              uid: widget.uid, car_number: _carnumber.text)));
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
                  child: Text("확인",
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
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
              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove("$test_i");
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
