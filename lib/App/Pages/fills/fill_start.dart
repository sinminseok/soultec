
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:soultec/App/Pages/fills/fill_setting.dart';
import 'package:soultec/Data/Object/user_object.dart';
import '../../../constants.dart';



//이제 여기서 블루투스 uuid랑 캐릭터리스틱 가져와서 인코딩 해줘서 해당 디바이스로 데이터를 넘겨준다.
class Fill_start extends StatefulWidget {
  User? user;
  Peripheral? peripheral;
  final String car_number;

  Fill_start({required this.user,required this.car_number,required this.peripheral});

  @override
  _Fill_start createState() => _Fill_start();
}

class _Fill_start extends State<Fill_start> {
  int pageIndex = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? user = widget.user;

    return SafeArea(
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

                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Fill_setting(user: user,car_number: widget.car_number,peripheral:widget.peripheral)));
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



  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
