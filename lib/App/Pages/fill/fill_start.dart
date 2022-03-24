
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/Pages/fill/fill_setting.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';

class Fill_start extends StatefulWidget {


  BluetoothDevice? device;

  //자동차 번호 전역으로 돌려줘야되는데 왜인진 모르겠는데 provider가 안먹어서 일단 위젯으로 데이터 넘김 추후 변경
  String? car_number;

  Fill_start({required this.device,required this.car_number});

  @override
  _Fill_start createState() => _Fill_start();
}

class _Fill_start extends State<Fill_start> {


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    String? user_token = Provider.of<Http_services>(context,listen: false).user_token!.token;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: size.height*0.2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("충전관리 솔루션",
                              style: TextStyle(fontSize: 22,),),
                            SizedBox(width: 2,),
                            Text("스마트필",
                              style: TextStyle(fontFamily: "numberfont", fontSize: 25, fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Image(
                            image: AssetImage('assets/images/mainimg.png'),
                            width: 90,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                          width: size.width*0.8,
                          height: size.height*0.3,
                          child: Image.asset(
                            'assets/gifs/main_img.gif',
                          )),
                    ),

                    SizedBox(height: size.height*0.03,),

                    InkWell(
                        onTap: () async{

                          Sound().play_sound("assets/mp3/success.mp3");
                          //user 정보 가져오기 (post receipt에서 어디 지점 유저인지 알아야댐)
                          User? user_info =await Http_services().get_user_info(user_token);
                          if(user_info == null){
                            showtoast("사용자 정보 오류 관리자에게 문의하세요");
                          }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Fill_setting(car_number:widget.car_number,device:widget.device)));
                          }
                        },

                        child:Container(
                            width: size.width*2,
                            height: size.height*0.2,
                            child: Image.asset("assets/images/start_button.png")
                        )

                    ),
                  ]),
            )),

    );
  }
}
