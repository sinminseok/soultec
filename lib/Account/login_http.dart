//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:soultec/Account/register_page.dart';
// import 'package:soultec/App/Pages/cars/car_number.dart';
// import 'package:soultec/Data/toast.dart';
// import 'package:soultec/constants.dart';
// import 'package:soultec/wrapper.dart';
// import 'package:http/http.dart' as http;
// import 'package:soultec/Data/User/user_object.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   bool isLogin = true;
//
//   // late Animation<double> containerSize;
//   // late AnimationController animationController;
//   Duration animationDuration = Duration(microseconds: 270);
//   // final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _passwordController = TextEditingController();
//
//   bool _isChecked = false;
//
//   // _postRequest() async {
//   //   //요청 url 가져오기
//   //   String url = 'http://example.com/login';
//   //
//   //   http.Response response = await http.post(
//   //     Uri(),
//   //     headers: <String, String>{
//   //       'Content-Type': 'application/x-www-form-urlencoded',
//   //     },
//   //     body: <String, String>{
//   //       'user_id': 'user_id_value',
//   //       'user_pwd': 'user_pwd_value'
//   //     },
//   //   );
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     // animationController =
//     //     AnimationController(vsync: this, duration: animationDuration);
//   }
//
//   @override
//   void dispose() {
//     // animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     User user = User("","");
//     String url = "http://localhost:8080/login";
//
//
//     Future save() async {
//       //encode ==>bytes  decode ==>String
//       var res = await http.post(url,
//           headers: {'Content-Type': 'application/json'},
//           body: json.encode({'email': user.email, 'password': user.password}));
//       print(res.body);
//       if (res.body != null) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CarNumberPage(uid: '',),
//             ));
//       }
//     }
//     Size size = MediaQuery.of(context).size;
//     double defaultRegisterSize = size.height - (size.height * 0.1);
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: kPrimaryColor,
//         body: Stack(
//           children: <Widget>[
//             //close button
//             AnimatedOpacity(
//               opacity: isLogin ? 0.0 : 1.0,
//               duration: animationDuration,
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: InkWell(
//                   child: Container(
//                       width: 50,
//                       height: 50,
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.grey,
//                       )),
//                   onTap: () {
//                     // animationController.reverse();
//                     setState(() {
//                       isLogin != isLogin;
//                     });
//                   },
//                 ),
//               ),
//             ),
//
//             Align(
//               alignment: Alignment.center,
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey ,
//                   child: Container(
//                     width: size.width,
//                     height: defaultRegisterSize,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: size.height * 0.02,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Column(
//                                 children: [
//                                   Text(
//                                     "충전 관리 솔루션",
//                                     style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black),
//                                   ),
//                                   SizedBox(
//                                     width: size.width * 0.03,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "SMART",
//                                         style: TextStyle(
//                                             fontSize: 38, color: Colors.white),
//                                       ),
//                                       Text(
//                                         "fill",
//                                         style: TextStyle(
//                                             fontSize: 38, color: Colors.yellow),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 30.0),
//                                 child: Image(
//                                   image: AssetImage('assets/images/mainimg.png'),
//                                   width: 80,
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           SizedBox(
//                             height: size.height * 0.25,
//                           ),
//
//                           Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                             width: size.width * 0.8,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: Colors.white),
//                             child: TextFormField(
//                               onChanged: (val) {
//                                 user.email = val;
//                               },
//                               controller: TextEditingController(text: user.email),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Email is Empty';
//                                 }
//                                 return null;
//                               },
//                               decoration: InputDecoration(
//                                   icon: Icon(Icons.person, color: Colors.black),
//                                   hintText: '기사번호 입력',
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(vertical: 10),
//                             padding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                             width: size.width * 0.8,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(4),
//                                 color: Colors.white),
//                             child: TextFormField(
//                               controller:
//                               TextEditingController(text: user.password),
//                               onChanged: (val) {
//                                 user.password = val;
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'password is Empty';
//                                 }
//                                 return null;
//                               },
//                               obscureText: true,
//                               keyboardType: TextInputType.visiblePassword, //inp
//                               decoration: InputDecoration(
//                                   icon: Icon(Icons.lock, color: Colors.black),
//                                   hintText: '비밀번호',
//                                   border: InputBorder.none),
//                             ),
//                           ),
//                           Container(
//                             width: size.width * 0.8,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Checkbox(
//                                         value: _isChecked,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _isChecked = value!;
//                                           });
//                                         }),
//                                     Text(
//                                       "로그인상태 유지",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ],
//                                 ),
//                                 FlatButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 RegisterScreen()));
//                                   },
//                                   child: Container(
//                                       child: Text("회원가입",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12))),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: size.height * 0.03,
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 save();
//                               }
//                             },
//                             borderRadius: BorderRadius.circular(20),
//                             child: Container(
//                               width: size.width * 0.8,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(4),
//                                   color: Colors.white),
//                               padding: EdgeInsets.symmetric(vertical: 20),
//                               alignment: Alignment.center,
//                               child: Text('로그인',
//                                   style: TextStyle(
//                                       color: Colors.black, fontSize: 16)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
