import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class First_page extends StatefulWidget {
  const First_page({Key? key}) : super(key: key);

  @override
  _First_page createState() => _First_page();
}

class _First_page extends State<First_page> {
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
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,

              child: TextFormField(
                controller: _inputController,
                decoration: InputDecoration(
                  helperStyle: TextStyle(color: Colors.black.withAlpha(10)),

                  hintText: 'input code number ',
                ),
              ),
            ),
          ),
          SizedBox(height: size.height*0.05,),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: size.width * 0.6,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor),
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text("confirm!",
                  style:
                  TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
