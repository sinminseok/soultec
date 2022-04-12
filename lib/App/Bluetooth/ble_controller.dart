import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';
import '../../Data/constants.dart';

class BLE_CONTROLLER {
  BluetoothCharacteristic? targetCharacteristic;
  Stream<List<int>>? stream_value;

  //해당 디바이스의 보낼 서비스 uuid를 를아 데이터 송신하는 함수
  Future<bool?> discoverServices_write(device, litter) async {
    bool check_uuid = false;
    if (device == null) {
      return null;
    }

    List<BluetoothService> services = await device!.discoverServices();
    //해당 uuid 검색 서비스가 없을경우 디바이스 디스크 id remove후 다시 페어링 페이지로

    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == BLE_UUID().POST_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == BLE_UUID().POST_CHARACTERISTIC_UUID) {
            targetCharacteristic = characteristic;

            if (litter == "가득") {
              writeData("가득");
              check_uuid = true;
            } else {
              check_uuid = true;
              writeData("$litter");
            }
          }
        });
      }
    });
    if (check_uuid == false) {
      return false;
    }
    return true;
  }

  //넘겨줄 string 데이터를 utf8로 인코딩 해서 송신하는 함수
  writeData(String data) async {
    if (targetCharacteristic == null) return;
    List<int> bytes = utf8.encode(data);
    //write메서드 파라미터는 list값
    await targetCharacteristic!.write(bytes);
  }

  //stream 으로 데이터 수신
  discoverServices_read(device) async {
    stream_value = null;
    if (device == null) {
      return;
    }

    List<BluetoothService> services = await device!.discoverServices();

    services.forEach((service) {
      if (service.uuid.toString() == BLE_UUID().GET_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == BLE_UUID().GET_CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream_value = characteristic.value;
          }
        });
      }
    });
  }

  //수신한데이터 파싱후 가공
  String dataParser(List<int>? dataFromDevice) {
    return utf8.decode(dataFromDevice!);
  }

  disconnect_device(device) async {
    await device!.disconnect();
  }
}
