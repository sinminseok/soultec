import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Account/login_page.dart';
import 'App/Pages/cars/car_number.dart';


class Wrapper extends StatefulWidget {
  final Peripheral? peripheral;

  Wrapper({required this.peripheral});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  var check;

  @override
  void initState() {
    super.initState();
    check = check_login();
    // animationController =
    //     AnimationController(vsync: this, duration: animationDuration);
  }

  Future<bool> check_login() async {
    final prefs = await SharedPreferences.getInstance();
// counter 키에 해당하는 데이터 읽기를 시도합니다. 만약 존재하지 않는 다면 0을 반환합니다.
    final counter = prefs.getInt('login');
    if (counter == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    //로그인 상태 유지했을땐 빠아로 DiscoveryPage()
    //아닌경우 login
    if (check!) {
      return LoginScreen();
    } else {
      return CarNumberPage(uid: null, peripheral: widget.peripheral);
    }
  }
}
