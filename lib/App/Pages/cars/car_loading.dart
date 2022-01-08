


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class CarLoadingPage extends StatelessWidget {
  const CarLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
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
                      "차량 조회",
                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Center(
              child: Text(
                "차량을 조회 중입니다.\n잠시만 기다려 주시기 바랍니다.",
                textAlign: TextAlign.center,
                style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            CupertinoActivityIndicator(radius: 50)
          ],
        ),
      ),
    );
  }
}