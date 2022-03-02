
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:soultec/App/Pages/fills/fill_setting.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';

class Fill_start extends StatefulWidget {
  User_token? user_token;
  String? user_id;
  final String car_number;
  BluetoothDevice? device;

  Fill_start({required this.user_token ,required this.user_id ,required this.car_number, required this.device});

  @override
  _Fill_start createState() => _Fill_start();
}

class _Fill_start extends State<Fill_start> {


  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User_token? user_token = widget.user_token;

    return SafeArea(
      child: WillPopScope(
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
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
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
                          User? user_info =await Http_services().get_user_info(widget.user_id, widget.user_token!.token);
                          if(user_info == null){
                            showtoast("사용자 정보 오류 관리자에게 문의하세요");
                          }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Fill_setting(user_token:user_token,user_id:widget.user_id, car_number: widget.car_number,device:widget.device,user_info:user_info)));
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
      ),

    );
  }
}
