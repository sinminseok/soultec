import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Utils/top_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/sound.dart';
import '../../../../Utils/toast.dart';
import '../../../Model/User_Model.dart';
import '../../../Presenter/ble_presenter.dart';
import '../../../Presenter/data_controller.dart';
import '../fill/fill_setting.dart';

class CarNumberPage extends StatefulWidget {
  BluetoothDevice? device;
  CarNumberPage({required this.device});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage>
    with SingleTickerProviderStateMixin {

  var check_tutorial_bool;

  List<Widget> children = [
    Image.asset("assets/images/arrow.png",),
    Image.asset("assets/images/arrow.png",color: Colors.transparent,),
  ];
  int interval = 500;

  void check_tutorial() async {
    final prefs = await SharedPreferences.getInstance();
    check_tutorial_bool = prefs.get('check_tutorial');
  }

  TextEditingController _carnumber_text = TextEditingController();
  bool check_connected = false;
  bool overlap_car = false;
  var return_carnumber;
  AnimationController? _controller;
  int _currentWidget = 0;

  @override
  void initState() {
    BLE_CONTROLLER().connect_devie(widget.device);
    showtoast("페어링 되었습니다 ${widget.device!.id}");

    _controller = new AnimationController(
        duration: Duration(milliseconds: interval), vsync: this);

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (++_currentWidget == children.length) {
            _currentWidget = 0;
          }
        });

        _controller!.forward(from: 0.0);
      }
    });

    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    check_tutorial_bool = null;
    overlap_car = false;
    super.dispose();
  }

  //ble device 기기 id값을 디스크에 저장 추후 자동 페어링 할때 사용

  @override
  Widget build(BuildContext context) {
    //http post car number 요청 보낼때 user의 token 값 필요
    var check_tutorial = Provider.of<Http_services>(context).check_tutorial;
    User_token? user_token = Provider.of<Http_services>(context).user_token;
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Top_widget(),
              SizedBox(
                height: size.height * 0.03,
              ),
              // InkWell(
              //   onTap: ()async{
              //   },
              //   child: Text("dasd")
              // ),
              Text(
                "차량 번호 4 자리를 입력해주세요",
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: kPrimaryColor),
                  child: Center(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "numberfont",
                        fontSize: 21,
                      ),
                      controller: _carnumber_text,
                      decoration: InputDecoration(
                        hintText: '',
                      ),
                    ),
                  ),
                ),
              ),
              overlap_car == false
                  ? Container(
                height: size.height * 0.34,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                    ),
                    Container(
                        width: size.width * 0.4,
                        child: Image.asset(
                          'assets/gifs/car_number.gif',
                        )),
                  ],
                ),
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
                          height: size.height * 0.06,
                        ),
                        Text(
                          "차량선택",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
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
                                    Sound().play_sound(
                                        "assets/mp3/click.mp3");

                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: Fill_Setting(
                                              device: widget.device,
                                                    car_number:
                                              return_carnumber[index]
                                                  .carNumber,
                                              sizee: size,
                                            )));
                                  },
                                  child: Container(
                                    child: ListTile(
                                      title: Center(
                                          child: Text(
                                            "${return_carnumber[index].carNumber}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "numberfont",
                                                color: HexColor("#4c5af5"),
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                        ),

                      ],

                    ),

                    Row(
                      children: [
                        check_tutorial != null ?Container() :
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50,right: 20),
                          child: Container(
                            width: size.width*0.1,
                            child: children[_currentWidget],
                          ),
                        ),
                        Container(
                            width: size.width * 0.25,
                            child: Image.asset(
                              'assets/gifs/select_car.gif',
                            )),
                      ],
                    ),
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
                    if (_carnumber_text.text.length < 4) {
                      Sound().play_sound("assets/mp3/error.mp3");
                      return showtoast("차량번호를 4자리 입력해주세요");
                    } else {
                      if (_carnumber_text.text == "") {
                        Sound().play_sound("assets/mp3/error.mp3");
                        return showtoast("차량 번호를 입력하세요");
                      } else {
                        return_carnumber = await Http_services().post_carnumber(
                            _carnumber_text.text, user_token!.token);
                        //중복되는 자동차 번호가 2개 이상일경우
                        if (return_carnumber!.length >= 2) {
                          Sound().play_sound("assets/mp3/click.mp3");
                          setState(() {
                            overlap_car = true;
                          });
                          return;
                        }
                        //등록된 차량 번호가 아닐경우
                        if (return_carnumber!.length == 0) {
                          Sound().play_sound("assets/mp3/error.mp3");
                          showtoast("등록되지 않은 차번호 입니다.재 확인 바랍니다.");
                        }
                        //등록된 차량 번호가 하나일경우
                        else {
                          Sound().play_sound("assets/mp3/start.mp3");

                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Fill_Setting(
                                    device: widget.device,
                                    car_number: _carnumber_text.text,
                                    sizee: size,
                                  )));
                        }
                      }
                    }
                  },
                  child: Container(
                      width: size.width * 0.7,
                      height: size.height * 0.1,
                      child: Image.asset("assets/images/red_button.png"))),
            ],
          ),
        ),
      ),
    );
  }
}