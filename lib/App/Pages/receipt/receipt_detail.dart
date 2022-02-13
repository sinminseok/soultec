import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/App/widgets/date_widget.dart';
import 'package:soultec/App/widgets/receipt_content.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../constants.dart';


class Recepit_detail extends StatefulWidget {
  final String? liter;
  final User? user;
  final String? car_number;

  Recepit_detail({required this.user , required this.liter , required this.car_number});

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

    String? liter = widget.liter;
    // String? user_id = widget.user!.id;
    // String? user_name = widget.user!.name;
    String? user_id = "1786";
    String? car_number = widget.car_number;
    Size size = MediaQuery.of(context).size;

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
                "0123-45gj6789",
                style: TextStyle(
                    color: Colors.red, fontSize: 29, fontFamily: "numberfont"),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),

              // Recepit_content(user_id ,car_number , liter ,todate),
              //Text(liter),
              SizedBox(
                height: size.height * 0.05,
              ),

              InkWell(
                onTap: (){
                  // post_receipt(widget.liter,date,,,);
                  //http post 이용내역
                  Navigator.pop(context);
                },
                child: Container(
                  width: size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text('제출하기',
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
