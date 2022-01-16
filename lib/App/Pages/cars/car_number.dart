  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],),
          elevation: 0,
        ),
        body: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.04,
              ),
              Text("차량조회",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
              SizedBox(
                height: size.height * 0.04,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Image(
                  //   image: AssetImage('assets/images/gtbimg.png'),
                  //   width: 100,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Image(
                      image: AssetImage('assets/images/mainimg.png'),
                      width: 130,
                    ),
                  ),


                ],
              ),
              SizedBox(height: size.height * 0.02,),
              Text("아직 차량을 등록하지 않았으면 ", style: TextStyle(fontSize: 20),),
              Text("관리자에게 문의하세요", style: TextStyle(fontSize: 20),),


              SizedBox(
                height: size.height * 0.05,
              ),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: kPrimaryColor.withAlpha(30)),
                child: TextFormField(
                  controller: _carnumber,

                  decoration: InputDecoration(
                      hintText: '자동차 번호를 입력해주세요 ex)00가 0000',
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
                  style: TextStyle(color: kPrimaryColor,
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
                      color: kPrimaryColor),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text(
                      "확인", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}