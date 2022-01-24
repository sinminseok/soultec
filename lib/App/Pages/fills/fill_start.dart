import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soultec/Data/toast.dart';
import '../../../constants.dart';
import 'fill_ing.dart';

class Home_page extends StatefulWidget {
  String? uid;

  Home_page({required this.uid});

  @override
  _Home_pageState createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  int pageIndex = 0;
  TextEditingController inputController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final values = ["가득", "리터"];
  String? _select_value;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Size size = MediaQuery.of(context).size;
    String user_name;
    user_name = auth.currentUser!.email.toString();

    return FutureBuilder<DocumentSnapshot?>(
      future: users.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        Map<String?, dynamic>? data =
            snapshot.data!.data() as Map<String?, dynamic>;
        return SafeArea(
          child: Scaffold(
            backgroundColor: kPrimaryColor,
              body: getBody(data["name"], size)),
        );
      },
    );
  }

  getBody(String user_name, Size size) {
    return SingleChildScrollView(
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("충전관리 솔루션",
                        style: TextStyle(fontSize: 12,),),
                      SizedBox(width: 2,),
                      Text("스마트필",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
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
              SizedBox(height: size.height*0.05,),
              Text("0123-45gj6789",style: TextStyle(color: Colors.red,fontSize: 29,fontFamily: "numberfont"),),
              SizedBox(height: size.height*0.4,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                width: size.width * 0.7,
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(20)),
                child: TextFormField(
                  controller: inputController,
                  decoration: InputDecoration(
                      hoverColor: Colors.black,
                      hintText: '',
                      ),
                ),
              ),
              SizedBox(height: size.height*0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    elevation: 17,
                    underline: Container(
                        decoration: BoxDecoration(
                            border:
                            Border.all(width: 0.5, color: Colors.white))),
                    hint: Text(
                      "가득/리터",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    value: _select_value,
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (val) => setState(() => {
                      _select_value = val.toString(),
                      if (val.toString() == "가득")
                        {inputController.text = "∞"}
                      else
                        {inputController.text = ""}
                    }),
                    items: [
                      for (var val in values)
                        DropdownMenuItem(
                          value: val,
                          child: SizedBox(
                            child: Text(
                              val.toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                    ],
                  ),
                  SizedBox(width: size.width * 0.2),
                  Text("LITTER",style: TextStyle(fontFamily: "numberfont",fontWeight: FontWeight.bold,fontSize: 24,color: Colors.red),),

                ],
              ),

              SizedBox(height: size.height*0.06,),

              InkWell(
                onTap: () {
                  if (_select_value == null) {
                    if (!inputController.text.isEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Filling(
                                  user_name: user_name,
                                  liter: inputController.text)));
                    } else {
                      showAlertDialog(context, "입력오류", "리터량을 설정해주세요");
                    }
                  } else if (_select_value == "가득") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Filling(user_name: user_name, liter: "가득")));
                  } else if (_select_value == "리터") {
                    if (!inputController.text.isEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Filling(
                                  user_name: user_name,
                                  liter: inputController.text)));
                    } else {
                      showAlertDialog(context, "입력오류", "리터량을 설정해주세요");
                    }
                  }
                },
                child: Container(
                  width: size.width * 0.8,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Text('주입시작',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
            ]),
    );
  }

  selectedTap(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
