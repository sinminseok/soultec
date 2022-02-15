import 'package:flutter/material.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';
import 'Account/login_page.dart';
import 'Data/Object/user_object.dart';


class Wrapper extends StatefulWidget {


  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var check;
  User? user;

  @override
  void initState() {
    super.initState();
    // check = check_login();
    // animationController =
    //     AnimationController(vsync: this, duration: animationDuration);
  }

//   Future<String?> check_login() async {
//     final prefs = await SharedPreferences.getInstance();
// // counter 키에 해당하는 데이터 읽기를 시도합니다. 만약 존재하지 않는 다면 0을 반환합니다.
//      user = prefs.getString('login');
//     if (user == null) {
//       return null;
//     } else {
//       return user;
//     }
//   }

  @override
  Widget build(BuildContext context) {
    //로그인 상태 유지했을땐 빠아로 DiscoveryPage()
    //아닌경우 login
      return LoginScreen();

  }
}
