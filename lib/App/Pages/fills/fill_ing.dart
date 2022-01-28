import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/App/Pages/receipt/receipt.dart';
import '../../../constants.dart';


class Filling extends StatefulWidget {
  final String liter;
  final String car_number;
  final String user_name;

  Filling({required this.user_name, required this.liter,required this.car_number});

  @override
  _FillingState createState() => _FillingState();
}

class _FillingState extends State<Filling> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor, body: getBody(size, widget.liter));
  }

  getBody(Size size, String v) {
    var liter = v;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: size.height*0.02,),
              Container(
                width: size.width*0.6,
                height: size.height*0.08,
                child: Center(child: Text("$liter" , style: TextStyle(fontFamily: "numberfont",fontSize: 45 , fontWeight: FontWeight.bold),)),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ),
              SizedBox(height: size.height*0.02,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(width: size.width * 0.4),
                  Text("LITTER",style: TextStyle(fontFamily: "numberfont",fontWeight: FontWeight.bold,fontSize: 24,color: Colors.red),),

                ],
              ),
              SizedBox(height: size.height*0.4,),
              //Text(liter),

              InkWell(
                onTap: () {
                  //data push
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Recepit(
                              user_name: widget.user_name,
                              liter: widget.liter , car_number: widget.car_number)));
                },
                  child:Container(
                  width: size.width*0.7,
                  height: size.height*0.1,
                  child: Image.asset("assets/images/play_button.png")
              )
              ),
            ]),
      ),
    );
  }
}
