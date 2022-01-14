import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soultec/Account/login_page.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';

import '../auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>
    with TickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkpasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  Duration animationDuration = Duration(microseconds: 270);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    Size size = MediaQuery.of(context).size;
    double viewInset = MediaQuery.of(context).viewInsets.bottom;
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defaultRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body:
          Align(
            alignment: Alignment.center,
            child: Container(
                width: size.width,
                height: defaultRegisterSize,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Image(
                          image: AssetImage('assets/images/mainimg.png'),
                          width: 110,
                        ),
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      Text(
                        '회원가입',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color: Colors.white),
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        height: size.height*0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              hintText: '기사번호',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        height: size.height*0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.face, color: Colors.black),
                              hintText: '이름',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        height: size.height*0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.black),
                              hintText: '비밀번호',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        height: size.height*0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _checkpasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.check, color: Colors.black),
                              hintText: '비밀번호 확인',
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      InkWell(
                        onTap: () async {
                          // if(_passwordController.text != _checkpasswordController){
                          //   showtoast("password is not confirm");
                          // }
                          try {
                            await AuthService().register(_emailController.text,
                                _passwordController.text, _nameController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                            if(_passwordController != _checkpasswordController) {
                              return showtoast("입력한 비밀번호가 다릅니다.");
                            }else{
                              if(_nameController == null){
                                showtoast("이름을 입력하세요");
                              }else{
                                return showtoast("기사번호를 입력하세요");
                              }
                            }
                            return showtoast("회원가입이 완료 되었습니다 로그인 페이지로 이동합니다!");
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: size.width * 0.8,

                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text("등록",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                      ),
                      SizedBox(height: size.height*0.02,),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Container(
                            child: Text(
                              "로그인페이지로 이동",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            
          ),

          //

      );

  }
}
