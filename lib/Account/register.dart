import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soultec/Account/login_main.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';
import 'package:animations/animations.dart';

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
  final TextEditingController _checkpasswordController = TextEditingController();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '회원가입',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image(
                      image: AssetImage('assets/images/mainimg.png'),
                      width: 200,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor.withAlpha(30)),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email, color: kPrimaryColor),
                            hintText: 'email',
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor.withAlpha(30)),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.visiblePassword, //inp
                        decoration: InputDecoration(
                            icon: Icon(Icons.face, color: kPrimaryColor),
                            hintText: 'name',
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor.withAlpha(30)),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword, //inp
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: kPrimaryColor),
                            hintText: 'password',
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kPrimaryColor.withAlpha(30)),
                      child: TextFormField(
                        controller: _checkpasswordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword, //inp
                        decoration: InputDecoration(
                            icon: Icon(Icons.check, color: kPrimaryColor),
                            hintText: 'confirm password',
                            border: InputBorder.none),
                      ),
                    ),
                    InkWell(
                      onTap: () async{
                        // if(_passwordController.text != _checkpasswordController){
                        //   showtoast("password is not confirm");
                        // }
                        try{
                          await AuthService().register(_emailController.text, _passwordController.text, _nameController.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          return showtoast("회원가입이 완료 되었습니다 로그인 페이지로 이동합니다!");
                        }catch(e){
                          print(e.toString());
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: size.width * 0.8,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: Text("Register",
                            style:
                            TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:660),
            child: Center(
              child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Container(
                    child: Text(
                        "로그인페이지로 이동",
                      style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold,fontSize: 12),
                    )
                ),
              ),
            ),
          ),




          Visibility(
            visible: !isLogin,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultRegisterSize,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image(
                        image: AssetImage('assets/images/mainimg.png'),
                        width: 200,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(30)),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email, color: kPrimaryColor),
                              hintText: 'Username',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(30)),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock, color: kPrimaryColor),
                              hintText: 'password',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(30)),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.check, color: kPrimaryColor),
                              hintText: 'password',
                              border: InputBorder.none),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPrimaryColor.withAlpha(30)),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword, //inp
                          decoration: InputDecoration(
                              icon: Icon(Icons.face, color: kPrimaryColor),
                              hintText: 'password',
                              border: InputBorder.none),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kPrimaryColor),
                          padding: EdgeInsets.symmetric(vertical: 20),
                          alignment: Alignment.center,
                          child: Text('SIGN UP',
                              style:
                              TextStyle(color: Colors.white, fontSize: 14)),
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
