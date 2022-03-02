


import 'package:flutter/cupertino.dart';

class Top_widget extends StatefulWidget {


  @override
  _Top_widgetState createState() => _Top_widgetState();
}

class _Top_widgetState extends State<Top_widget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height:size.height*0.2),
        Column(
          children: [
            // SizedBox(height: ,)
            Text(
              "충전관리 솔루션",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              "스마트필",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Image(
            image: AssetImage('assets/images/mainimg.png'),
            width: 60,
          ),
        ),
      ],
    );

  }
}
