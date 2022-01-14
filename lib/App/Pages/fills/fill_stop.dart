import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/widgets/drawer.dart';
import '../../../constants.dart';
import 'fill_end.dart';


class FillStop extends StatefulWidget {
  final String liter;
  final String user_name;

  FillStop({required this.user_name,required this.liter});

  @override
  _FillStopState createState() => _FillStopState();
}

class _FillStopState extends State<FillStop> {
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
            "주 입 멈 춤",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.08,
          ),
          Text(
            widget.user_name+"님",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "${widget.liter}리터로 주입을 원하십니다.",
            style: TextStyle(fontSize: 20),
          ),
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
            height: size.height * 0.10,
          ),
          InkWell(
            onTap: () {
              //data push
              Navigator.push(context, MaterialPageRoute(builder: (context) => FillEnd(user_name : widget.user_name,liter: widget.liter)));
            },
            child: Container(
              width: size.width * 0.7,
              height: 45,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: kPrimaryColor),
              padding: EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child: Text('정 량', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text("리터 [0] L", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text("정량을 맞추시려면", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("정량 버튼을 터치해 주세요.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}