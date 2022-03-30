// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:soultec/App/Bluetooth/ble_controller.dart';
// import 'package:soultec/App/Bluetooth/blue_scan.dart';
// import 'package:soultec/App/widgets/top_widget.dart';
// import 'package:soultec/Sound/sound.dart';
// import 'package:soultec/Data/toast.dart';
// import 'package:soultec/RestAPI/http_service.dart';
// import '../../../constants.dart';
// import 'fill_ing.dart';
//
// //이제 여기서 블루투스 uuid랑 캐릭터리스틱 가져와서 인코딩 해줘서 해당 디바이스로 데이터를 넘겨준다.
// class Fill_setting extends StatefulWidget {
//  // BluetoothDevice? device;
//   String? car_number;
//
//   Fill_setting(
//       {
//         required this.car_number,
//       // required this.device,
//       });
//
//   @override
//   _Fill_setting createState() => _Fill_setting();
// }
//
// class _Fill_setting extends State<Fill_setting> {
//
//   final values = ["가득", "리터"];
//   String? _select_value;
//   TextEditingController inputController = TextEditingController();
//
//   bool? ble_return = null;
//   @override
//   initState() {
//     super.initState();
//     //connectToDevice();
//   }
//
//   @override
//   dispose(){
//     ble_return = null;
//     super.dispose();
//   }
//
//   //디바이스 연결
//   // connectToDevice() async {
//   //   if (widget.device == null) return;
//   //   await widget.device!.connect(autoConnect: false);
//   //
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     String? user_id= Provider.of<Http_services>(context).user_id;
//     Size size = MediaQuery.of(context).size;
//
//     return WillPopScope(
//
//       onWillPop: () async => false,
//       child: Scaffold(
//             backgroundColor: kPrimaryColor,
//             body: SingleChildScrollView(
//               child: Column(children: [
//                 Top_widget(),
//                 // InkWell(child: Text("TEST"),
//                 // onTap: ()async{
//                 //   print(widget.device!.state.listen((event) {print(event);}));
//                 //   // print(widget.device!.state.listen((event) {print(event);}));
//                 //   // print("GGGGGG");
//                 // }),
//                 //
//                 Text(
//                   "${user_id} -- ${widget.car_number}",
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 29,
//                     fontFamily: "numberfont",
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(0.0),
//                   child: Container(
//                       width: size.width * 0.8,
//                       height: size.height * 0.4,
//                       child: Image.asset(
//                         'assets/gifs/main_img.gif',
//                       )),
//                 ),
//                 Container(
//                   width: size.width * 0.6,
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           color: Colors.black,
//                           style: BorderStyle.solid,
//                           width: 1),
//                       color: kPrimaryColor),
//                   child: TextFormField(
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: "numberfont",
//                       fontSize: 29,
//                     ),
//                     controller: inputController,
//                     decoration: InputDecoration(
//                       hintText: '리터량 입력',
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.height * 0.03,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     DropdownButton(
//                       elevation: 17,
//                       underline: Container(
//                           decoration: BoxDecoration(
//                               border:
//                                   Border.all(width: 0.5, color: Colors.black))),
//                       hint: Text(
//                         "가득/리터",
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 14,
//                         ),
//                       ),
//                       value: _select_value,
//                       dropdownColor: Colors.white,
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                       onChanged: (val) => setState(() => {
//                       Sound().play_sound("assets/mp3/success.mp3"),
//                             _select_value = val.toString(),
//                             if (val.toString() == "가득")
//                               {inputController.text = "∞"}
//                             else
//                               {inputController.text = ""}
//                           }),
//                       items: [
//                         for (var val in values)
//                           DropdownMenuItem(
//                             value: val,
//                             child: SizedBox(
//                               child: Text(
//                                 val.toString(),
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     SizedBox(width: size.width * 0.2),
//                     Text(
//                       "LITTER",
//                       style: TextStyle(
//                           fontFamily: "numberfont",
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24,
//                           color: Colors.red),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: size.height * 0.06,
//                 ),
//                 InkWell(
//                     onTap: () async {
//                        if (_select_value == null) {
//                         if (!inputController.text.isEmpty) {
//                           Sound().play_sound("assets/mp3/success.mp3");
//
//                           // ble_return =await BLE_CONTROLLER().discoverServices_write(widget.device , inputController.text);
//                           // if(ble_return == false){
//                           //   showtoast("주유기 블루트수를 다시 선택해주세요");
//                           //
//                           //   final prefs = await SharedPreferences.getInstance();
//                           //   prefs.remove('${widget.device!.id}');
//                           //
//                           //   Navigator.push(
//                           //       context,
//                           //       MaterialPageRoute(
//                           //           builder: (context) => Blue_scan(
//                           //           )));
//                           // }
//
//
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Filling(
//                                       car_number:widget.car_number,
//                                       liter: int.parse('${inputController.text}') ,
//
//
//                         )));
//                         } else {
//                           Sound().play_sound("assets/mp3/error.mp3");
//                           showtoast("리터량을 설정해주세요!");
//                         }
//                       } else if (_select_value == "가득") {
//                         Sound().play_sound("assets/mp3/success.mp3");
//
//                         //루투스 디바이스를 잘못선택했을때
//                         //  ble_return =await BLE_CONTROLLER().discoverServices_write(widget.device , "가득");
//                         // if(ble_return == false){
//                         //   showtoast("주유기 블루트수를 다시 선택해주세요");
//                         //
//                         //   final prefs = await SharedPreferences.getInstance();
//                         //   prefs.remove('${widget.device!.id}');
//                         //
//                         //   Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) => Blue_scan(
//                         //           )));
//                         // }
//                         //가득 넘길떄 몇 리터로 넘겨야 할지
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Filling(
//                                   car_number:widget.car_number,
//                                     liter: 100,
//                               )));
//                       } else if (_select_value == "리터") {
//                          //사용자가 직접 리터량을 설정해줬을때
//                         if (!inputController.text.isEmpty) {
//                           Sound().play_sound("assets/mp3/success.mp3");
//
//                           //블루투스 디바이스를 잘못선택했을때
//                           //  ble_return =await BLE_CONTROLLER().discoverServices_write(widget.device , inputController.text);
//                           // if(ble_return == false){
//                           //   showtoast("주유기 블루트수를 다시 선택해주세요");
//                           //
//                           //   final prefs = await SharedPreferences.getInstance();
//                           //   prefs.remove('${widget.device!.id}');
//                           //
//                           //   Navigator.push(
//                           //       context,
//                           //       MaterialPageRoute(
//                           //           builder: (context) => Blue_scan(
//                           //           )));
//                           // }
//
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Filling(
//                                     car_number:widget.car_number,
//                                       liter: int.parse('${inputController.text}'),
//
//                               )));
//                         } else {
//                           Sound().play_sound("assets/mp3/error.mp3");
//                           return showtoast("리터량을 설정해주세요!");
//                         }
//                       }
//                     },
//                     child: Container(
//                         width: size.width * 0.7,
//                         height: size.height * 0.1,
//                         child: Image.asset("assets/images/play_button.png"))),
//               ]),
//             )
//       ),
//     );
//   }
//
// }
