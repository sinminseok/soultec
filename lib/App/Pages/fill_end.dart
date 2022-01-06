import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/widgets/drawer.dart';

class FillEnd extends StatefulWidget {
  //late final String? uid;

  //Filling({required this.uid});

  @override
  _FillEndState createState() => _FillEndState();
}

class _FillEndState extends State<FillEnd> {
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
            "주 입 완 료",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.08,
          ),
          Text(
            "[김영솔]님 환영합니다.\n",
            style: TextStyle(fontSize: 22),
          ),
          Text(
            "[30]리터로 주입이 끝났습니다.",
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
          Text("리터 [30] L", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
