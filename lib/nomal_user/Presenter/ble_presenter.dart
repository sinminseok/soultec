import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/constants.dart';

class BLE_CONTROLLER {
  BluetoothCharacteristic? targetCharacteristic;
  Stream<List<int>>? device_number_stream;

  //블루투스 디바이스 연결 함수
  void connect_devie(device) async {
    await device.connect(autoConnect: false);
  }

  //올바르게 선택했다면 디바이스 장치 기억
  void remember_device(device_id) async {
    String? check_device_id = device_id.toString();
// shared preferences 얻기
    final prefs = await SharedPreferences.getInstance();
// 값 저장하기
    prefs.setString('$check_device_id', check_device_id);
    return;
  }

  //해당 주유기에게 리터량을 내포해
  Future<bool?> ble_post_litter(device, litter) async {
    bool check_uuid = false;
    List<BluetoothService> services = await device!.discoverServices();
    //해당 uuid 검색 서비스가 없을경우 디바이스 디스크 id remove후 다시 페어링 페이지로
    services.forEach((service) {
      // do something with service
      var value_return;
      if (service.uuid.toString() == BLE_UUID().POST_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() ==
              BLE_UUID().POST_CHARACTERISTIC_UUID) {
            if (litter == "가득") {
              List<int> bytes = ascii.encode("‘<‘ + “LD” + 주유기번호 + 단가 + Q + 가득 + ‘>");
              value_return = characteristic.write(bytes);
              characteristic.value;

              if (value_return == "success") {
                check_uuid = true;
              }
              //주유기 연결은 성공했으나 비정상 처리 됐을때 나타나는 문제이다.
              if (value_return == "false") {
                //재귀로 돌려줘야되려나?
                check_uuid = true;
              }
            } else {
              //‘<‘ + “LD” + ID + UP + MODE + VAL + ‘>’
              List<int> bytes =
                  ascii.encode("‘<‘ + “LD” + 주유기번호 + 단가 + Q + litter + ‘>");
              value_return = characteristic.write(bytes);
              if (value_return == "ACK") {
                check_uuid = true;
              }
              if (value_return == "false") {
                check_uuid = true;
              }
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

  //해당 블루투스 디바이스(주유기) 번호 추출 함수
  Future<String?> read_device_information(device) async {
    var device_number;
    var device_number_return;
    List<BluetoothService> services = await device!.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == BLE_UUID().POST_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() ==
              BLE_UUID().POST_CHARACTERISTIC_UUID) {
            List<int> bytes = ascii.encode("‘<‘ + “RI” + ‘>’");
            device_number = characteristic.write(bytes);
            //characteristic.value;
            device_number_return = ascii.decode(device_number).substring(0, 2);
          }
        });
      }
    });

    if (device_number_return == null) {
      return null;
    } else {
      //주유기 번호 (정보)
      return device_number_return;
    }
  }

  writeData_filling(String data) async {
    List<int> bytes = ascii.encode(data);

    String? start_fill_return = ascii.decode(bytes);
    if (start_fill_return == "‘[‘ + ”LD” + ID + ’:’ + ”NAK” + ‘]’") {
      return "false";
    } else {
      return "success";
    }
  }

  //stream 으로 데이터 수신
  //주유 완료 보고로 명령을 넣은다음 완료된 응답을 받을때까지 stream 으로 관찰한다.
  discoverServices_read(device) async {
    List<BluetoothService> services = await device!.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == BLE_UUID().GET_SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() ==
              BLE_UUID().GET_CHARACTERISTIC_UUID) {
            List<int> bytes =
                ascii.encode("‘[‘ + “LE”+ ID + ET + UP + CQ + CP + CT + ‘]’");
            characteristic.write(bytes);
            device_number_stream = characteristic.value;
            // characteristic.setNotifyValue(!characteristic.isNotifying);
            // device_number_stream = characteristic.value;
          }
        });
      }
    });
  }

  //수신한데이터 파싱후 가공
  String dataParser(List<int>? dataFromDevice) {
    return ascii.decode(dataFromDevice!);
  }

  disconnect_device(device) async {
    await device!.disconnect();
  }
}
