import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soultec/Utils/constants.dart';
import 'package:soultec/Utils/top_widget.dart';

import '../../../../Utils/sound.dart';

class FU_Fill_finish extends StatefulWidget {
  const FU_Fill_finish({Key? key}) : super(key: key);

  @override
  _FU_Fill_finishState createState() => _FU_Fill_finishState();
}

class _FU_Fill_finishState extends State<FU_Fill_finish> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          Top_widget(),
          Center(
            child: Container(

                width: size.width * 0.9,
                height: size.height * 0.3,
                child: Image.asset(
                  'assets/gifs/inputer_img.gif',
                )
            ),
          ),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('주유가 완료되었습니다!',
                    textStyle: TextStyle(
                        color: Colors.black, fontFamily: "fonttext"))
              ],
              isRepeatingAnimation: true,
            ),
          ),
          SizedBox(height: size.height*0.1,),
          Text("종료 버튼을 눌러 어플을 종료하세요"),
          SizedBox(height: size.height*0.16,),
          InkWell(
              onTap: () async {
                Sound().play_sound("assets/mp3/success.mp3");
                SystemNavigator.pop();
              },
              child: Container(
                  width: size.width * 0.6,
                  height: size.height * 0.07,
                  child: Image.asset("assets/images/finish_button.png"))),
        ],
      ),
    );
  }
}
