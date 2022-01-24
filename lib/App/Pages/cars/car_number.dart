  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/widgets/bluetooth.dart';
import 'package:soultec/Data/database.dart';
import 'package:soultec/Data/toast.dart';
import '../../../constants.dart';
import '../fills/fill_start.dart';
import 'car_register.dart';

class CarNumberPage extends StatefulWidget {
  final String? uid;

  CarNumberPage({required this.uid});

  @override
  State<CarNumberPage> createState() => _CarNumberPageState();
}

class _CarNumberPageState extends State<CarNumberPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController _carnumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Bluetooth_Service>(context);
    Size size = MediaQuery
        .of(context)
        .size;
    final providerUserModel = Provider.of<DatabaseService?>(context);
    print(providerUserModel);

    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(

          child: Column(
            children: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("충전관리 솔루션",
                        style: TextStyle(fontSize: 12,),),
                      SizedBox(width: 2,),
                      Text("스마트필",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Image(
                      image: AssetImage('assets/images/mainimg.png'),
                      width: 60,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: size.height * 0.3,
              ),

              Text("직접 입력",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(
                height: size.height * 0.01,
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
                  controller: _carnumber,
                  decoration: InputDecoration(
                      hintText: '차량 번호 4자리 입력',
                      border: InputBorder.none),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Center(
                child: Text(
                  "확인을 누르면 조회를 시작합니다.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: size.height * 0.05,
              ),

              InkWell(
                onTap: () async {
                  if (!_carnumber.text.isEmpty) {
                    print('how');
                    var result = await DatabaseService(uid: null).readCar(
                        _carnumber.text);
                    if (result == true) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Home_page(uid: widget.uid,)));
                    } else {
                      showAlertDialog(
                          context, '등록된 차량이 아닙니다', '관리자에게 문의해주세요');
                    }
                  } else {
                    print('sex');
                    return await showAlertDialog(context, "입력오류", "차량 번호를 입력해주세요");
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text(
                      "확인", style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}