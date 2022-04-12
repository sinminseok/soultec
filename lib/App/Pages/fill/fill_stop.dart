import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/Pages/receipt/receipt_list.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Data/sound.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import '../../../Data/constants.dart';

class Filling_stop extends StatefulWidget {
  final String? car_number;
  final int? liter;


  Filling_stop(
      {required this.liter, required this.car_number});

  @override
  _Filling_stop createState() => _Filling_stop();
}

class _Filling_stop extends State<Filling_stop> {
  //노르딕 디바이스 연결

  @override
  initState() {
    super.initState();
    Sound().play_sound("assets/mp3/success.mp3");
    showtoast("지정한 주입량이 아닌 정량으로 주입되었습니다!");
    post_receipt();
    // disconnect_device();

    //주입이 멈췄을때 자동으로 서버에 이용내역 전송
    //post_receipt();
  }

  post_receipt() async {
    // String? user_id= Provider.of<Http_services>(context).user_id;
    String? user_token = Provider.of<Http_services>(context).user_token!.token;
    await Http_services().post_receipt(
        9, widget.liter, widget.car_number.toString(), user_token);
  }

  // disconnect_device() async {
  //   await widget.device!.disconnect();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: getBody(size, widget.liter, context),
    );
  }

  getBody(Size size, int? liter, thiscontext) {

    String? user_id = Provider.of<Http_services>(context).user_id;
    String? user_token = Provider.of<Http_services>(context).user_token!.token;

    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Top_widget(),
            Text(
              "$user_id -- ${widget.car_number}",
              style: TextStyle(
                color: Colors.red,
                fontSize: 29,
                fontFamily: "numberfont",
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              width: size.width * 0.6,
              height: size.height * 0.08,
              child: Center(
                  child: Text(
                "$liter",
                style: TextStyle(
                    fontFamily: "numberfont",
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: size.width * 0.4),
                Text(
                  "LITTER",
                  style: TextStyle(
                      fontFamily: "numberfont",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.red),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
            Container(
              width: size.width * 0.6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: size.width * 0.8,
                        height: size.height * 0.1,
                        child: Image.asset("assets/gifs/main_img.gif")),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text('${liter} ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 34,
                              fontFamily: "numberfont")),
                    ),
                    Text('완료되었습니다.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            fontFamily: "numberfont")),
                  ]),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            InkWell(
                onTap: () async {
                  Sound().play_sound("assets/mp3/success.mp3");

                  var data_list =
                      await Http_services().load_receipt_list(user_token);
                  //
                  Navigator.push(
                      thiscontext,
                      MaterialPageRoute(
                          builder: (context) => Receipt_list(
                                data_list: data_list,
                                car_number: widget.car_number,
                              )));
                  showtoast("주유가 완료 되었습니다!");
                },
                child: Container(
                    width: size.width * 0.7,
                    height: size.height * 0.1,
                    child: Image.asset("assets/images/stop_button.png"))),
          ]),
    );
  }
}
