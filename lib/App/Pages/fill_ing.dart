import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/widgets/drawer.dart';

import 'package:soultec/auth.dart';

import '../../constants.dart';

class Filling extends StatefulWidget {
  //late final String? uid;

  //Filling({required this.uid});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  int pageIndex = 0;

  String? _select_value;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: My_Drawer(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: getBody(size));
  }

  getBody(Size size) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "주 입 중",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          Text(
            "[김영솔]님 환영합니다\n",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "[30]L로 주입을 원하십니다.",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(width: size.width * 0.8, child: Divider(color: Colors.black, thickness: 1.0)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text("주유 중입니다.계속해서 주유하세요.", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.blue)),
          Text("계속해서 주유하세요.", style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.12,
          ),
          Text("리터[0]L"),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text("주입 중입니다.\n잠시만 기다려 주시기 바랍니다.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
