import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/constants.dart';
import 'package:intl/intl.dart';

import 'date_widget.dart';

class Recepit_content extends StatelessWidget {
  final String? user_id;
  final String? car_number;
  final String? litter;


  Recepit_content(this.user_id ,this.car_number , this.litter);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var date = getToday();

    print(date);
    return Container(

      color: Colors.white,
      height: size.height*0.55,
      width: size.width*0.7,
      child: Column(
        children: [
          Text("이용 내역",style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          Text("",style:TextStyle(fontSize: 14),),
          Text("상 호: (주) 경기 운수",style:TextStyle(fontSize: 14),),
          Text("대표 : 이무개",style:TextStyle(fontSize: 14),),
          Text("경기도 평택시 포송읍 서동대로 417",style:TextStyle(fontSize: 14),),
          Text("사업지:010 - 9174 -1764 ",style:TextStyle(fontSize: 14),),
          Text("이용 내역",style:TextStyle(fontSize: 14),),
          Text("",style:TextStyle(fontSize: 14),),
          Text("사용일시 : $date",style:TextStyle(fontSize: 14),),
          Text("승인번호",style:TextStyle(fontSize: 14),),
          Text("주유기 번호:",style:TextStyle(fontSize: 14),),
          Text("============================",style:TextStyle(fontSize: 14),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("제품명"),
              Text("수량"),
              Text("기사번호"),
              Text("차량 번호"),
            ],
          ),

          Text("----------------------------------------------------------",style:TextStyle(fontSize: 14),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("요소수"),
              Text("$litter"),
              Text("$user_id"),
              Text("$car_number"),
            ],
          ),
          Text("----------------------------------------------------------",style:TextStyle(fontSize: 14),),
          Text("총 충전량:312.412",style:TextStyle(fontSize: 14),),
          Text("----------------------------------------------------------",style:TextStyle(fontSize: 14),),
          Text("soultec 제출",style:TextStyle(fontSize: 14),),

        ],
      )

    );
  }
}
