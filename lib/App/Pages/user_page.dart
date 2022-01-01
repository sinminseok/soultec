import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(height: size.height*0.2,
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
    );
  }
}


