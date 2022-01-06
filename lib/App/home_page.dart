import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/widgets/drawer.dart';
import 'package:soultec/App/Pages/fill_ing.dart';

import '../constants.dart';

class Home_page extends StatefulWidget {
  late final String? uid;

  Home_page({required this.uid});

  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  int pageIndex = 0;
  TextEditingController inputController = TextEditingController();

  final values = [
    "가득",
    "리터"
  ];
  var select_firest = "가득";
  String? _select_value;
  String? _liter;

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
          Image(
            image: AssetImage('assets/images/mainimg.png'),
            width: 140,
          ),
          Text("빠르고 편한 주입"),
          Text(
            "스마트필",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text("기사님 환영합니다"),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text("페어링이 정상적으로 연결 되었습니다!"),
          Text("리터랑을 설정해주십시요"),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                elevation: 16,
                underline: Container(decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black38))),
                hint: Text(
                  "가득/리터",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                value: _select_value,
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.black,
                ),
                onChanged: (val) => setState(() => _select_value = val.toString()),
                items: [
                  for (var val in values)
                    DropdownMenuItem(
                      value: val,
                      child: SizedBox(
                        child: Text(
                          val.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: size.width * 0.05),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                width: size.width * 0.4,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.black.withAlpha(30)),
                child: TextFormField(
                  controller: inputController,
                  decoration: InputDecoration(hintText: '가득/리터', border: InputBorder.none),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          InkWell(
            onTap: () {
              //data push
              print('click');
              print(inputController);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Filling(l: inputController)));
            },
            child: Container(
              width: size.width * 0.8,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text('주입시작', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
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
