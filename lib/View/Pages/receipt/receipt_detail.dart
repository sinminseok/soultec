import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Model/Receipt_Model.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/sound.dart';

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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "충전관리 솔루션",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "스마트필",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
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
              height: size.height * 0.05,
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
                    width: size.width * 1.3,
                    height: size.height * 0.6,
                    child: Image.asset("assets/images/receipt_detail.png")),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.2,
                    ),
                    Container(
                      width: size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
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
                            "승인번호 : ${widget.list_Data.approvalNumber}",
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
                            "=============================",
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
                            "------------------------------------------------------------",
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
                            "------------------------------------------------------------",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "총 충전량: ${widget.list_Data.amount} ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "---------------------------------------------------------------",
                            style: TextStyle(fontSize: 14),
                          ),
                          Center(
                              child: Text(
                            "soultec 제출",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
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
