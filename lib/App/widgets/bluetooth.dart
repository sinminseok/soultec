import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBlue? flutterBlue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//ble instance 생성
    flutterBlue = FlutterBlue.instance;
  }

  void _startscan() {
// 검색 시작 -> 검색 시간 4초
    flutterBlue!.startScan(timeout: Duration(seconds: 5));


    var subscription = flutterBlue!.scanResults.listen((results) {
      // do something with scan results

      for (ScanResult r in results) {
        print(
            'Device Name : ${r.device.name} // Device ID : ${r.device.id} // Device rssi: ${r.rssi}');
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
        // We have to work on the UI in this part
        );
  }
}
