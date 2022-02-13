import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import 'package:soultec/constants.dart';

import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  //Form controller
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  //Object 객체 생성, http get 이후 json을 데이터를 Object 객체로 대입
  User? user;
  //자동로그인 checkbox가 확인되면 get_userinfo 실행해서 저장된 user의 information 을 가져온다
  var disk_user_info = [];

  //디스크에 저장된 id,pw 저장 변수
  String? checkbox_state = null;
  String? user_id_disk;
  String? user_pw_disk;
  bool _isChecked = false;
  bool auth_login = false;
  bool? http_return;



  //이전에 로그인 할떄 자동 로그인을 체크했는데 알려주는 함수
  void check_box()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      checkbox_state = prefs.getString("check_login");
    });
  }

  Future<void> initConnectivity() async {
    print("start ");
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile data");
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print("wifi");
    }
    else if( connectivityResult.toString() == "ConnectivityResult.none"){
      showAlertDialog(context,"네트워크 오류","와이파이나 데이터를 켜주세요");
    }
  }


  

  @override
  void initState() {
    super.initState();
    initConnectivity();

    check_box();
    if(checkbox_state != null){
      disk_user_info =Http_services().get_userinfo() as List;
      user_id_disk = disk_user_info[0];
      user_pw_disk == disk_user_info[1];
      //initState 에서 비동기로 반환한 객체 가져와지나? 나주엥 연동후ㅜ 테스트
      user =Http_services().auto_login(user_id_disk, user_pw_disk) as User?;
      auth_login = true;
      SystemChrome.setEnabledSystemUIOverlays([]);
    }else{
      auth_login= false;
    }
    //이 코드 뭐임?ㅋㅋ
    SystemChrome.setEnabledSystemUIOverlays([]);

  }

  @override
  void dispose() {
    auth_login = false;
    // animationController.dispose();
    user = null;
    disk_user_info=[];
    _isChecked = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);

    return  auth_login ? DiscoveryPage(user: user) :Scaffold(
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultRegisterSize,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: size.height*0.1,),
                                Text(
                                  "충전 관리 솔루션",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: size.width * 0.03,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "SMART",
                                      style: TextStyle(
                                          fontSize: 38, color: Colors.white),
                                    ),
                                    Text(
                                      "fill",
                                      style: TextStyle(
                                          fontSize: 38, color: Colors.yellow),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0,top: 60),
                              child: Image(
                                image: AssetImage('assets/images/mainimg.png'),
                                width: 80,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.15,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white),
                          child: TextFormField(
                            style: TextStyle(fontFamily: "numberfont",fontSize: 23),
                            controller: _userIDController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person, color: Colors.black),
                                hintText: '기사번호 입력',
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white),
                          child: TextFormField(
                            style: TextStyle(fontFamily: "numberfont",fontSize: 23),
                            controller: _passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword, //inp
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock, color: Colors.black),
                                hintText: '비밀번호',

                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: _isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      }),
                                  Text(
                                    "로그인상태 유지",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.black,
                                        fontFamily: "numberfont"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        InkWell(
                          onTap: () async {

                            // user = await Http_services().login(_userIDController.text,_passwordController.text,_isChecked);
                            // if(user != null){
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               DiscoveryPage(user: user,)));
                            // }else{
                            //   return showAlertDialog(context, "로그인 실패", "기사번호와 비밀번호를 다시 한번 \n 확인해주세요.");
                            // }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DiscoveryPage(user: null,)));

                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: size.width*0.7,
                              height: size.height*0.2,
                              child: Image.asset(
                                'assets/images/button_login.png',
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}