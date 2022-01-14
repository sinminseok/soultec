import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soultec/Account/register_page.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';
import 'package:soultec/wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(microseconds: 270);
  final formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isChecked =false;


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
      body: Stack(
        children: <Widget>[
          //close button
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                    )),
                onTap: () {
                  animationController.reverse();
                  setState(() {
                    isLogin != isLogin;
                  });
                },
              ),
            ),
          ),

          Align(
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
                      SizedBox(height: size.height*0.02,),


                      Text(
                        '충전관리솔루션_스마트필',
                        style:
                        TextStyle( fontSize: 19,fontWeight: FontWeight.bold,color:Colors.white),
                      ),
                      SizedBox(height: size.height*0.04,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text("SMART",style: TextStyle(fontSize: 38,color: Colors.white),),
                          SizedBox(width: size.width*0.03,),
                          Text("fill",style: TextStyle(fontSize: 38,color: Colors.yellow),)
                        ],
                      ),
                      Text(
                        '환영합니다.',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 24,color:Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              hintText: '기사번호 입력',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
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
                        width: size.width*0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                      value: _isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked = value!;
                                        });
                                      }),

                                Text("로그인상태 유지",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            FlatButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                              },
                              child: Container(
                                  child: Text(
                                      "회원가입",
                                      style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 12)
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height*0.03,
                      ),
                      InkWell(
                        onTap: ()async{
                          try{
                            print('userlogin');
                            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                            print("...");
                            User? user = userCredential.user;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                            return showtoast("Login!");

                          }on FirebaseAuthException catch(e){
                            print('login error');
                            print(e.toString());
                            if(e.toString() == "[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred."){
                              return showtoast("네트워크 연결을 확인하세요.");
                            }

                            return showtoast("등록된 직원이 아닙니다.관리자에게 문의 하십시오.");
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text('로그인',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
