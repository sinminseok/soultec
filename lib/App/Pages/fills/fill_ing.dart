
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'fill_stop.dart';

class Filling extends StatefulWidget {
  final String liter;
  final String user_name;

  Filling({required this.user_name,required this.liter});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Text(
            widget.user_name +"님",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "${widget.liter}리터로 주입을 원하십니다.",
            style: TextStyle(fontSize: 20),
          ),
          //Text(liter),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(width: size.width * 0.8, child: Divider(color: Colors.black, thickness: 1.0)),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text("주입 중입니다.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
          Text("계속해서 주입해주세요.", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.09,
          ),
          Text("리터 [0] L", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.1,
          ),
          Text("주입 중입니다.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("잠시만 기다려 주시기 바랍니다.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.04,
          ),
          InkWell(
            onTap: () {
              //data push
              Navigator.push(context, MaterialPageRoute(builder: (context) => FillStop(user_name : widget.user_name,liter: widget.liter)));
            },
            child: Container(
              width: size.width * 0.8,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text('다음', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ]),
      ),
    );
  }
}