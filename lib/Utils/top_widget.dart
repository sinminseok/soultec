import 'package:flutter/cupertino.dart';

class Top_widget extends StatefulWidget {

  @override
  _Top_widgetState createState() => _Top_widgetState();

}

class _Top_widgetState extends State<Top_widget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: size.height * 0.15),
        Container(
          width: size.width*0.3,
          child: Image(
            image: AssetImage(
                'assets/images/smartfill_logo.png'),
            width: 70,
          ),
        ),
      ],
    );
  }
}
