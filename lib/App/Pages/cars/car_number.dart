import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/App/Pages/fill/fill_start.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';


class CarNumberPage extends StatefulWidget {

  BluetoothDevice? device;
  CarNumberPage({required this.device});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {

  TextEditingController _carnumber_text = TextEditingController();
  bool check_connected = false;
   
  @override
  void initState() {
    remember_device(widget.device!.id);
    connect_devie();
    showtoast("페어링 되었습니다 ${widget.device!.id}");
    super.initState();
  }

  void connect_devie()async{
    await widget.device!.connect(autoConnect: false);
  }



  @override
  void dispose(){
    super.dispose();
  }

  //ble device 기기 id값을 디스크에 저장 추후 자동 페어링 할때 사용
  void remember_device(device_id)async{
    String? check_device_id = device_id.toString();
// shared preferences 얻기
    final prefs = await SharedPreferences.getInstance();
// 값 저장하기
    prefs.setString('$check_device_id',check_device_id);
    return;
  }


  @override
  Widget build(BuildContext context) {
    //http post car number 요청 보낼때 user의 token 값 필요
    User_token? user_token= Provider.of<Http_services>(context).user_token;


    Size size = MediaQuery.of(context).size;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Top_widget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: size.width * 0.6,
                        child: Image.asset(
                          'assets/gifs/car_number.gif',
                        )),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  InkWell(
                    onTap: ()async{
                      await widget.device!.connect(autoConnect: false);
                      widget.device!.state.listen((deviceState) {
                        print("${new DateTime.now()} Device State: $deviceState");
                      });
                    },
                    child: Text("dasd"),
                  ),
                  Text(
                    "직접 입력",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "numberfont"),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
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

                  SizedBox(
                    height: size.height * 0.001,
                  ),
                  Center(
                    child: Text(
                      "확인을 누르면 조회를 시작합니다.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "numberfont",
                          color: Colors.red.shade300,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),

                  InkWell(
                      onTap: () async{
                        print("GGG");
                        print(user_token!.token);
                        //http get car_number return bool
                        var return_carnumber = await Http_services().post_carnumber(_carnumber_text.text,user_token.token);

                        if(return_carnumber == true){
                          Sound().play_sound("assets/mp3/click.mp3");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Fill_start(car_number:_carnumber_text.text,
                                          device:widget.device)));

                        }else{
                          Sound().play_sound("assets/mp3/error.mp3");
                          showtoast("등록되지 않은 차번호 입니다.");
                        }

                      },
                      child: Container(
                          width: size.width * 0.7,
                          height: size.height * 0.1,
                          child: Image.asset("assets/images/play_button.png"))),

                ],
              ),
            ),
        ),
    );
  }
}
