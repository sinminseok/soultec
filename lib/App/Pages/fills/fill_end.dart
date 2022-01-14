import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/widgets/bluetooth.dart';
import 'package:soultec/App/widgets/drawer.dart';
import '../../../constants.dart';


class FillEnd extends StatefulWidget {
  final String liter;
  final String user_name;

  FillEnd({required this.user_name, required this.liter});

  @override
  _FillEndState createState() => _FillEndState();
}

class _FillEndState extends State<FillEnd> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    var provider = Provider.of<Bluetooth_Service>(context);
    String? address = provider.device_address;
    return SafeArea(
      child: Scaffold(
          drawer: My_Drawer(context),
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "주 입 완 료",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Text(
                      widget.user_name + "님",
                      style: TextStyle(fontSize: 22),
                    ),
                    Text(
                      "${widget.liter}리터로 주입이 끝났습니다.",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(width: size.width * 0.8,
                        child: Divider(color: Colors.black, thickness: 1.0)),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Image(
                        image: AssetImage('assets/images/mainimg.png'),
                        width: 120,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text("리터 ${widget.liter}L", style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text("주입이 완료되었습니다.", style: TextStyle(fontSize: 17)),
                    Text("노즐을 주입기에 걸어주세요.", style: TextStyle(fontSize: 17)),
                    Text("수고하셨습니다. 안녕하가세요.", style: TextStyle(fontSize: 17,)),
                    SizedBox(
                      height: size.height * 0.04,
                    ),

                    InkWell(
                      onTap: () {
                        print(address);
                        SystemNavigator.pop();
                         provider.dispose_device(address!);
                         print("this is");
                         //추후에 블루투스 페어링끊기는지 확인해보자
                         print(address);
                        SystemNavigator.pop();
                        //data push
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: kPrimaryColor),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Text('완료',
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ]),
            ),
          )),
    );
  }

// getBody(Size size) {
//   return Align(
//     alignment: Alignment.center,
//     child: SingleChildScrollView(
//       child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text(
//           "주 입 완 료",
//           style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(
//           height: size.height * 0.08,
//         ),
//         Text(
//           widget.user_name +"님",
//           style: TextStyle(fontSize: 22),
//         ),
//         Text(
//           "${widget.liter}리터로 주입이 끝났습니다.",
//           style: TextStyle(fontSize: 20),
//         ),
//         SizedBox(
//           height: size.height * 0.02,
//         ),
//         Container(width: size.width * 0.8, child: Divider(color: Colors.black, thickness: 1.0)),
//         SizedBox(
//           height: size.height * 0.03,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 30.0),
//           child: Image(
//             image: AssetImage('assets/images/cartoonimg.png'),
//             width: 140,
//           ),
//         ),
//         SizedBox(
//           height: size.height * 0.03,
//         ),
//         Text("리터 ${widget.liter}L", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(
//           height: size.height * 0.02,
//         ),
//         Text("주입이 완료되었습니다.", style: TextStyle(fontSize: 17)),
//         Text("노즐을 주입기에 걸어주세요.", style: TextStyle(fontSize: 17)),
//         Text("수고하셨습니다. 안녕하가세요.", style: TextStyle(fontSize: 17,)),
//         SizedBox(
//           height: size.height * 0.04,
//         ),
//
//         InkWell(
//           onTap: () {
//             provider.
//             //data push
//           },
//           child: Container(
//             width: size.width * 0.8,
//             height: 60,
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
//             padding: EdgeInsets.symmetric(vertical: 20),
//             alignment: Alignment.center,
//             child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 16)),
//           ),
//         ),
//       ]),
//     ),
//   );
// }
}