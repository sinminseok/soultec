import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/App/widgets/date_widget.dart';
import 'package:soultec/App/widgets/receipt_content.dart';
import 'package:soultec/Data/Object/receipt_object.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';


class Recepit_detail extends StatefulWidget {

  final Receipt_object list_Data;

  Recepit_detail({required this.list_Data});

  @override
  _Recepit_detail createState() => _Recepit_detail();
}

class _Recepit_detail extends State<Recepit_detail> {



  @override
  void initState(){
    super.initState();
    // Http_services().post_receipt(widget.liter, date, widget.car_number, widget.user!.userID);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // String? user_id = widget.user!.id;
    // String? user_name = widget.user!.name;



    return Scaffold(
        backgroundColor: kPrimaryColor, body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
            children: [
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                height: size.height * 0.05,
              ),

              Container(

                  color: Colors.white,
                  height: size.height*0.55,
                  width: size.width*0.7,
                  child: Column(
                    children: [
                      Text("이용 내역",style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text("",style:TextStyle(fontSize: 14),),
                      Text("${widget.list_Data.branchName}",style:TextStyle(fontSize: 14),),
                      Text("대표 : ${widget.list_Data.branchCeo}",style:TextStyle(fontSize: 14),),
                      Text("${widget.list_Data.branchAddress}",style:TextStyle(fontSize: 14),),
                      Text("담당자 번호 : ${widget.list_Data.branchTEL} ",style:TextStyle(fontSize: 14),),
                      Text("이용 내역",style:TextStyle(fontSize: 14),),
                      Text("",style:TextStyle(fontSize: 14),),
                      Text("사용일시 : ${(widget.list_Data.dateTime)!.substring(0,10)}",style:TextStyle(fontSize: 14),),
                      Text("승인번호 : ${widget.list_Data.approvalNumber}",style:TextStyle(fontSize: 14),),
                      Text("주유기 번호: ${widget.list_Data.pumpNumber}",style:TextStyle(fontSize: 14),),
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
                          Text("${widget.list_Data.amount}"),
                          Text("${widget.list_Data.username}"),
                          Text("${widget.list_Data.carNumber}"),
                        ],
                      ),
                      Text("----------------------------------------------------------",style:TextStyle(fontSize: 14),),
                      Text("총 충전량:312.412",style:TextStyle(fontSize: 14),),
                      Text("----------------------------------------------------------",style:TextStyle(fontSize: 14),),
                      Text("soultec 제출",style:TextStyle(fontSize: 14),),

                    ],
                  )

              ),
              //Text(liter),
              SizedBox(
                height: size.height * 0.05,
              ),

              InkWell(
                onTap: () async{
                  Navigator.of(context).pop();

                },
                child: Container(

                  width: size.width * 0.3,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text('뒤로가기',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
            ]),
      ),
    ));
  }

// getBody(Size size, String v) {
//   var liter = v;
//   return SafeArea(
//     child: SingleChildScrollView(
//       child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                       "충전관리 솔루션",
//                       style: TextStyle(
//                         fontSize: 12,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 2,
//                     ),
//                     Text(
//                       "스마트필",
//                       style: TextStyle(
//                           fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0),
//                   child: Image(
//                     image: AssetImage('assets/images/mainimg.png'),
//                     width: 60,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: size.height * 0.05,
//             ),
//             Text(
//               "0123-45gj6789",
//               style: TextStyle(
//                   color: Colors.red, fontSize: 29, fontFamily: "numberfont"),
//             ),
//             SizedBox(
//               height: size.height * 0.05,
//             ),
//
//             Recepit_content(),
//             //Text(liter),
//             SizedBox(
//               height: size.height * 0.05,
//             ),
//
//             InkWell(
//               onTap: () {
//                 provider.dispose_device(address!);
//                 print("this is");
//                 //data push
//               },
//               child: Container(
//                 width: size.width * 0.8,
//                 height: 60,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     color: kPrimaryColor),
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 alignment: Alignment.center,
//                 child: Text('완료',
//                     style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//           ]),
//     ),
//   );
// }
}