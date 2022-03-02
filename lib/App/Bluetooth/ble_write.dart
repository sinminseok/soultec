import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';
import '../../constants.dart';

class BLE_CONTROLLER{

  BluetoothCharacteristic? targetCharacteristic;
  Stream? stream;


  //해당 디바이스의 보낼 서비스 uuid를 를아 데이터 송신하는 함수
  discoverServices_write(device , litter) async {
    if (device == null) return;

    List<BluetoothService> services = await device!.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == POST_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == POST_CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;
            if(litter == "가득"){
              writeData("해당 리터 량");
            }else{
              writeData("해당 리터 량");
            }
            writeData("해당 리터 량");
            // setState(() {
            //   connectionText = "All Ready with ${widget.device!.name}";
            // });
          }
        });
      }
    });
  }

  //넘겨줄 string 데이터를 utf8로 인코딩 해서 송신하는 함수
  writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic!.write(bytes);
  }

  //stream 으로 데이터 수신
  discoverServices_read(device) async {
    if (device == null) {
      return;
    }

    List<BluetoothService> services = await device!.discoverServices();

    services.forEach((service) {
      if (service.uuid.toString() == GET_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == GET_CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

          }
        });
      }
    });

  }

  //수신한데이터 파싱후 가공
  String dataParser(List<int>? dataFromDevice) {
    return utf8.decode(dataFromDevice!);
  }

}