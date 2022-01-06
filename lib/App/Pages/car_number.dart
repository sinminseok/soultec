
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'car_loading.dart';

class CarNumberPage extends StatelessWidget {
  const CarNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: size.height * 0.2,
                child: Stack(
                  children: [
                    Container(
                      height: size.height * 0.2 - 27,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )),
                    ),
                    Center(
                      child: Text(
                        "차량 인증",
                        style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Center(
                child: Text(
                  "카메라를 차량 번호판에 맞춰줍니다\n조회가 완료 될 때까지 기다려 주십시오.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.15,
              ),
              Center(
                child: Text(
                  "프레임에 맞춰지면 조회를 시작합니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor, fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(width: 500, child: Divider(color: Colors.red, thickness: 1.0)),
              SizedBox(
                height: size.height * 0.02,
              ),
              Center(
                child: Text(
                  "차량 번호를 직접 입력하실 수 있습니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '00가0000',
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Center(
                child: Text(
                  "확인을 누르면 조회를 시작합니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarLoadingPage()));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text("확인", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
    );
  }
}