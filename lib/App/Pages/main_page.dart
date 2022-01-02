import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';
import 'inputPages/Test.dart';
import 'inputPages/first_input.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Main_page extends StatefulWidget {
  const Main_page({Key? key}) : super(key: key);

  @override
  _Main_pageState createState() => _Main_pageState();
}

class _Main_pageState extends State<Main_page> {

  final TextEditingController _inputController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(height: size.height*0.2,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.2 - 27,
                decoration: BoxDecoration(color: kPrimaryColor,borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
              )
            ],
          ),
          ),
          SizedBox(height: size.height*0.01,),
          Center(child: Text("REGISTRATION NUMBER" , style: TextStyle(color: kPrimaryColor , fontSize: 24 , fontWeight: FontWeight.normal),),),
          SizedBox(height: size.height*0.15,),
          SizedBox(height: size.height*0.05,),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: size.width * 0.6,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor),
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text("Connect!",
                  style:
                  TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
