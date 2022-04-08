import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/Account/login_page.dart';
import 'package:soultec/App/Pages/cars/car_number.dart';
import 'package:soultec/Data/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../Data/constants.dart';

class Start_page extends StatefulWidget {


  //자동차 번호 전역으로 돌려줘야되는데 왜인진 모르겠는데 provider가 안먹어서 일단 위젯으로 데이터 넘김 추후 변경


  @override
  _Start_page createState() => _Start_page();
}

class _Start_page extends State<Start_page> {
  @override
  initState() {
    super.initState();
    initConnectivity();
    // connect_device();
  }

  //네트워크 연결 확인 함수
  Future<void> initConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.mobile) {
    } else if (connectivityResult == ConnectivityResult.wifi) {
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "충전관리 솔루션",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "스마트필",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
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
                    width: size.width * 0.8,
                    height: size.height * 0.3,
                    child: Image.asset(
                      'assets/gifs/main_img.gif',
                    )),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              InkWell(
                  onTap: () async {
                    Sound().play_sound("assets/mp3/start.mp3");

                    //user 정보 가져오기 (post receipt에서 어디 지점 유저인지 알아야댐)
                    // print(user_info!.authorityDtoSet);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarNumberPage()));
                  },
                  child: Container(
                      width: size.width * 2,
                      height: size.height * 0.2,
                      child: Image.asset("assets/images/start_button.png"))),
            ]),
          )
    );
  }
}
