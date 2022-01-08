import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/Data/database.dart';
import 'package:soultec/Data/toast.dart';

import '../../../constants.dart';
import 'car_number.dart';

class CarRegister extends StatefulWidget {
  final String? uid;
  CarRegister({required this.uid});

  @override
  State<CarRegister> createState() => _CarRegister();
}

class _CarRegister extends State<CarRegister> {
  TextEditingController _carnumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: kPrimaryColor,),
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.04,
            ),
            Text("차량 등록",style: TextStyle(fontSize: 26 , fontWeight: FontWeight.bold),),

            SizedBox(
              height: size.height * 0.04,
            ),
            Image(
              image: AssetImage('assets/images/cartoonimg.png'),
              width: 140,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            FlatButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CarNumberPage(uid: widget.uid,)));
              },
              child: Container(
                  child: Text(
                      "등록 된 차량이있으면 조회를 시작해주세요",
                      style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 12)
                  )
              ),
            ),


            SizedBox(
              height: size.height * 0.06,
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
                "확인을 누르면 차량 등록이 완료 됩니다.",
                textAlign: TextAlign.center,
                style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
              onTap: () {
                DatabaseService(uid: widget.uid ).updateCarData(_carnumber.text);
                return showtoast("차량 등록이 완료되었습니다 .");
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: size.width * 0.6,
                height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kPrimaryColor),
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Text("등록", style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}