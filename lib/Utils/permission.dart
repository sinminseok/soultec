
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soultec/Utils/toast.dart';

class Permission_handler{

  Future<void> initConnectivity(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (connectivityResult.toString() == "ConnectivityResult.none") {
      showAlertDialog(context, "네트워크 오류", "와이파이나 데이터를 켜주세요");
    }
  }

  Future<bool> requestCameraPermission(BuildContext context) async {

    PermissionStatus status = await Permission.camera.request();
    if(!status.isGranted) { // 허용이 안된 경우
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                FlatButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      return false;
    }
    return true;
  }

  Future<bool> requestBLUE(BuildContext context) async {
    print("start ble request");
    PermissionStatus status = await Permission.bluetooth.request();

    if(!status.isGranted){// 허용이 안된 경우
      print("허용안됨");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                FlatButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      return false;
    }
    print("허용됨");
    return true;
  }


}