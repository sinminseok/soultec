import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/widgets/drawer.dart';

import '../../../constants.dart';


class FillEnd extends StatefulWidget {
  final String liter;
  final String user_name;

  FillEnd({required this.user_name , required this.liter});

  @override
  _FillEndState createState() => _FillEndState();
}

class _FillEndState extends State<FillEnd> {
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
            "주 입 완 료",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.08,
          ),
          Text(
            widget.user_name +"님",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "${widget.liter}리터로 주입이 끝났습니다.",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(width: size.width * 0.8, child: Divider(color: Colors.black, thickness: 1.0)),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Image(
              image: AssetImage('assets/images/cartoonimg.png'),
              width: 140,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text("리터 ${widget.liter}L", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.05,
          ),
          Text("주입이 완료되었습니다.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("노즐을 주입기에 걸어주세요.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("수고하셨습니다. 안녕하가세요.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}