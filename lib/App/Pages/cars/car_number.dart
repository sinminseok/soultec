
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soultec/Data/database.dart';
import 'package:soultec/Data/toast.dart';
import '../../../constants.dart';
import '../../home_page.dart';
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
    Size size = MediaQuery.of(context).size;
    final providerUserModel = Provider.of<DatabaseService?>(context);
    print(providerUserModel);

    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: kPrimaryColor,leading: Container(),),
      body:  SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.04,
              ),
              Text("차량조회",style: TextStyle(fontSize: 26 , fontWeight: FontWeight.bold),),

              SizedBox(
                height: size.height * 0.04,
              ),
              Image(
                image: AssetImage('assets/images/cartoonimg.png'),
                width: 140,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarRegister(uid: widget.uid,)));
                },
                child: Container(
                    child: Text(
                        "아직 차량 등록을 하지 않았으면 등록해주세요.",
                        style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 12)
                    )
                ),
              ),

              SizedBox(
                height: size.height * 0.04,
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
                  style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: size.height * 0.05,
              ),

              InkWell(
                onTap: () async{
                  var result = await DatabaseService(uid: null).readCar(_carnumber.text);
                  print('g');
                  print(result);

                  if(result == true){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home_page(uid: widget.uid,)));
                  }else{
                    showAlertDialog(
                        context, '등록된 차량이 아닙니다','');
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text("확인", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
    );
  }
}