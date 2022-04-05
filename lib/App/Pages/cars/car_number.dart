import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Pages/fill/fill_start.dart';
import 'package:soultec/App/Pages/fill/fill_setting.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';

class CarNumberPage extends StatefulWidget {
  //BluetoothDevice? device;
  // CarNumberPage({required this.device});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {
  TextEditingController _carnumber_text = TextEditingController();
  bool check_connected = false;
  bool overlap_car = false;
  var return_carnumber;
  @override
  void initState() {
    //remember_device(widget.device!.id);
    // connect_devie();
    // showtoast("페어링 되었습니다 ${widget.device!.id}");
    super.initState();
  }

  void connect_devie() async {
    //await widget.device!.connect(autoConnect: false);
  }

  @override
  void dispose() {
    overlap_car = false;
    super.dispose();
  }

  //ble device 기기 id값을 디스크에 저장 추후 자동 페어링 할때 사용
  void remember_device(device_id) async {
    String? check_device_id = device_id.toString();
// shared preferences 얻기
    final prefs = await SharedPreferences.getInstance();
// 값 저장하기
    prefs.setString('$check_device_id', check_device_id);
    return;
  }

  @override
  Widget build(BuildContext context) {
    //http post car number 요청 보낼때 user의 token 값 필요
    User_token? user_token = Provider.of<Http_services>(context).user_token;

    List<String?> car_numbers = ["1234", "1768"];

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Top_widget(),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "차량 번호 4 자리를 입력해주세요",
              style: TextStyle(fontSize: 24, fontFamily: "numberfont"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1),
                    color: kPrimaryColor),
                child: Center(
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "numberfont",
                      fontSize: 21,
                    ),
                    controller: _carnumber_text,
                    decoration: InputDecoration(
                      hintText: '차량번호 4 자리 입력',
                    ),
                  ),
                ),
              ),
            ),
            overlap_car == false
                ?
                //중복되지 않을때
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width * 0.5,
                        child: Image.asset(
                          'assets/gifs/car_number.gif',
                        )),
                  )
                :
                //중복될때
                Container(
                    height: size.height * 0.34,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Text(
                              "차량선택",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: size.width * 0.5,
                              height: size.height * 0.15,
                              child: ListView.builder(
                                  itemCount: return_carnumber.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Fill_Setting(
                                                      car_number:
                                                      return_carnumber[index].carNumber,
                                                      sizee: size,
                                                    )));
                                      },
                                      child: Container(
                                        child: ListTile(
                                          title: Center(
                                              child: Text(
                                            "${return_carnumber[index].carNumber}",
                                            style: TextStyle(
                                                fontFamily: "numberfont",
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        Container(
                            width: size.width * 0.3,
                            child: Image.asset(
                              'assets/gifs/select_car.gif',
                            )),
                      ],
                    ),
                  ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Center(
              child: Text(
                "단추를 누르면 조회를 시작합니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "numberfont",
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            InkWell(
                onTap: () async {
                  print("ddd");
                  print(_carnumber_text.text.length);
                  print(user_token!.token);

                  if(_carnumber_text.text.length <4){
                    return showtoast("차량번호를 4자리 입력해주세요");
                  }else{
                    if(_carnumber_text.text == ""){
                      return showtoast("차량 번호를 입력하세요");
                    }else{
                      return_carnumber = await Http_services()
                          .post_carnumber(_carnumber_text.text, user_token.token);

                      if(return_carnumber!.length >=2 ){
                        setState(() {
                          overlap_car = true;
                        });

                        return;
                      }if(return_carnumber!.length == 0){
                        Sound().play_sound("assets/mp3/error.mp3");
                        showtoast("등록되지 않은 차번호 입니다.재 확인 바랍니다.");
                      }else{
                        Sound().play_sound("assets/mp3/start.mp3");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Fill_Setting(
                                  car_number: _carnumber_text.text,
                                  sizee: size,
                                )));
                      }
                    }
                  }
                  //http get car_number return bool



                  // if (return_carnumber == true) {
                  //   if (overlap_car == true) {
                  //     return showtoast("차량 번호를 선택하세요");
                  //   }
                  //   Sound().play_sound("assets/mp3/start.mp3");
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => Fill_Setting(
                  //                 car_number: _carnumber_text.text,
                  //                 sizee: size,
                  //               )));
                  // } else {
                  //   Sound().play_sound("assets/mp3/error.mp3");
                  //   showtoast("등록되지 않은 차번호 입니다.재 확인 바랍니다.");
                  // }
                },
                child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.1,
                    child: Image.asset("assets/images/red_button.png"))),
          ],
        ),
      ),
    );
  }
}
