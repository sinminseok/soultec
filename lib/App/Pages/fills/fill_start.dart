
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

import 'package:soultec/App/Pages/fills/fill_setting.dart';
import 'package:soultec/Data/User/user_object.dart';
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
    String car_number = widget.car_number;
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

  // getBody( Size size) {
  //   String car_number = widget.car_number;
  //   return SingleChildScrollView(
  //       child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     Text("충전관리 솔루션",
  //                       style: TextStyle(fontSize: 12,),),
  //                     SizedBox(width: 2,),
  //                     Text("스마트필",
  //                       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
  //                   ],
  //                 ),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 20.0),
  //                   child: Image(
  //                     image: AssetImage('assets/images/mainimg.png'),
  //                     width: 60,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: size.height*0.05,),
  //
  //             Text("$car_number",style: TextStyle(color: Colors.red,fontSize: 29,fontFamily: "numberfont",fontWeight: FontWeight.bold),),
  //             Padding(
  //               padding: const EdgeInsets.all(1.0),
  //               child: Container(
  //                   width: size.width*0.8,
  //                   height: size.height*0.4,
  //                   child: Image.asset(
  //                     'assets/gifs/main_img.gif',
  //                   )),
  //             ),
  //             Container(
  //               margin: EdgeInsets.symmetric(vertical: 5),
  //               padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //               width: size.width * 0.7,
  //               decoration: BoxDecoration(
  //                   border: Border.all(
  //                       color: Colors.black,
  //                       style: BorderStyle.solid,
  //                       width: 1
  //                   ),
  //                   color: kPrimaryColor),
  //               child: Center(
  //                 child: TextFormField(
  //                   style: TextStyle(fontFamily: "numberfont",fontSize: 29,),
  //                   controller: inputController,
  //                   decoration: InputDecoration(
  //
  //                       hintText: '',
  //                       ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: size.height*0.03,),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 DropdownButton(
  //                   elevation: 17,
  //                   underline: Container(
  //                       decoration: BoxDecoration(
  //                           border:
  //                           Border.all(width: 0.5, color: Colors.black))),
  //                   hint: Text(
  //                     "가득/리터",
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                   value: _select_value,
  //                   dropdownColor: Colors.white,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                   ),
  //                   onChanged: (val) => setState(() => {
  //                     _select_value = val.toString(),
  //                     if (val.toString() == "가득")
  //                       {inputController.text = "∞"}
  //                     else
  //                       {inputController.text = ""}
  //                   }),
  //                   items: [
  //                     for (var val in values)
  //                       DropdownMenuItem(
  //                         value: val,
  //                         child: SizedBox(
  //                           child: Text(
  //                             val.toString(),
  //                             textAlign: TextAlign.left,
  //                             style: TextStyle(
  //                               color: Colors.black87,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //
  //                   ],
  //                 ),
  //                 SizedBox(width: size.width * 0.2),
  //                 Text("LITTER",style: TextStyle(fontFamily: "numberfont",fontWeight: FontWeight.bold,fontSize: 24,color: Colors.red),),
  //
  //               ],
  //             ),
  //
  //             SizedBox(height: size.height*0.06,),
  //
  //             InkWell(
  //               onTap: () {
  //                 if (_select_value == null) {
  //                   if (!inputController.text.isEmpty) {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => Filling(
  //                                 user_name: "minseok",
  //                                 liter: inputController.text,car_number: widget.car_number,)));
  //                   } else {
  //                     showAlertDialog(context, "입력오류", "리터량을 설정해주세요");
  //                   }
  //                 } else if (_select_value == "가득") {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) =>
  //                               Filling(user_name: "miseopk", liter: "가득",car_number:widget.car_number)));
  //                 } else if (_select_value == "리터") {
  //                   if (!inputController.text.isEmpty) {
  //                     Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) => Filling(
  //                                 user_name: "minseok=",
  //                                 liter: inputController.text,car_number : widget.car_number)));
  //                   } else {
  //                     showAlertDialog(context, "입력오류", "리터량을 설정해주세요");
  //                   }
  //                 }
  //               },
  //               child:Container(
  //                 width: size.width*0.7,
  //                 height: size.height*0.1,
  //                 child: Image.asset("assets/images/play_button.png")
  //               )
  //
  //             ),
  //           ]),
  //   );
  // }

  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
