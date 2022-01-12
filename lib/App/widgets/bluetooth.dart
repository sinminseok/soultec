import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class Bluetooth_Service with ChangeNotifier{
  String? device_address;

  //블루투스 디바이스를 선택해서 연결해주는  함수
  //지금 애뮬러이터에서는 블루투스 디바이스를 못찾아서 휴대폰 sdk로 다운받고 커넥션 되는지 확인해봐야댐
  Future<void> connect_device(String address) async{
// Some simplest connection :F
    try {
      device_address=address;
      BluetoothConnection connection = await BluetoothConnection.toAddress(device_address);
      print('Connected to the device');
      connection.input!.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        connection.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          connection.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    }
    catch (exception) {
      print('Cannot connect, exception occured');
      print(exception);
    }

    notifyListeners();
  }

  //블루투스 페어링을 끊어주는 함수
  Future<void> dispose_device(String address)async{
    BluetoothConnection connection = await BluetoothConnection.toAddress(address);
    connection.close();
    notifyListeners();
  }


}