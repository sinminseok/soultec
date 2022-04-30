import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Model/Receipt_Model.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/sound.dart';
import '../../../Utils/top_widget.dart';

class Recepit_detail extends StatefulWidget {
  final Receipt_object list_Data;

  Recepit_detail({required this.list_Data});

  @override
  _Recepit_detail createState() => _Recepit_detail();
}

class _Recepit_detail extends State<Recepit_detail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Top_widget(),

              ],
            ),

            Text(
              "${widget.list_Data.username} -- ${widget.list_Data.carNumber!}",
              style: TextStyle(
                color: Colors.red,
                fontSize: 29,
                fontFamily: "numberfont",
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Stack(
              children: [
                Container(
                    width: size.width * 1.4,
                    height: size.height * 0.6,
                    child: Image.asset("assets/images/receipt_detail.png")),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.15,
                    ),
                    Container(
                      width: size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.08,
                          ),
                          Text(
                            "",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "상호 : ${widget.list_Data.branchName}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "대표 : ${widget.list_Data.branchCeo}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.list_Data.branchAddress}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "담당자 번호 : ${widget.list_Data.branchTEL} ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "사용일시 : ${(widget.list_Data.dateTime)!.substring(0, 10)}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),

                          Text(
                            "주유기 번호: ${widget.list_Data.pumpNumber}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(""),
                          Text(
                            "==================================",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "제품명",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "수량",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "기사번호",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "차량 번호",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "-------------------------------------------------------------------",
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "요소수",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.list_Data.amount}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.list_Data.username}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${widget.list_Data.carNumber}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "-------------------------------------------------------------------",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "총 충전량: ${widget.list_Data.amount} ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "-------------------------------------------------------------------",
                            style: TextStyle(fontSize: 14),
                          ),
                          Center(
                            child: Text(
                              "스마트필 주식회사",
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
                onTap: () async {
                  Sound().play_sound("assets/mp3/success.mp3");
                  Navigator.of(context).pop();
                },
                child: Container(
                    width: size.width * 0.6,
                    height: size.height * 0.07,
                    child: Image.asset("assets/images/check_button.png"))),
          ]),
        ));
  }
}
