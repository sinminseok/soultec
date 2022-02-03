import 'package:flutter/material.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';

import '../wrapper.dart';


class Start_page extends StatefulWidget {
  @override
  _Start_pageState createState() => _Start_pageState();
}

class _Start_pageState extends State<Start_page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);

    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              width: size.width,
              height: defaultRegisterSize,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/gtbimg.png'),
                      width: 100,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      '빠르고 편한 주입',
                      style: TextStyle(fontSize: 19),
                    ),
                    Text(
                      '스마트필 시작.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Image(
                        image: AssetImage('assets/images/mainimg.png'),
                        width: 140,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    Text(
                      "페어링이 시작 됩니다 잠시만 기다려 주십시오.",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wrapper()));
                      },
                      //Text("연결",style: TextStyle(fontWeight: FontWeight.bold),),
                      child: Icon(Icons.bluetooth),
                      splashColor: Colors.blue,
                      color: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
