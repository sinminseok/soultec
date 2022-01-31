import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soultec/App/Pages/cars/car_number.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';
import '../../wrapper.dart';
import 'blue_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscoveryPage extends StatefulWidget {
  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  //ble 매니저 생성
  BleManager _bleManager = BleManager();

  //상태 변환 변수
  bool _isScanning = false;
  bool _connected = false;

  Peripheral? _curPeripheral; // 연결된 장치 변수
  List<BleDeviceItem> deviceList = []; // BLE 장치 리스트 변수
  String _statusText = '';

  @override
  void initState() {
    init();
    scan();
    super.initState();
  }

  //
  @override
  void dispose() {
    //dispose 안해주면 충돌할수 있음
    _curPeripheral = null;
    _isScanning = false;
    _connected = false;
    _bleManager.destroyClient();

    super.dispose();
  }

  // BLE 초기화 함수
  void init() async {
    //ble 매니저 생성
    await _bleManager
        .createClient(
            restoreStateIdentifier: "example-restore-state-identifier",
            restoreStateAction: (peripherals) {
              peripherals.forEach((peripheral) {
                print("Restored peripheral: ${peripheral.name}");
              });
            })
        .catchError((e) => print("Couldn't create BLE client  $e"))
        .then((_) => _checkPermissions()) //매니저 생성되면 권한 확인
        .catchError((e) => print("Permission check error $e"));
  }

  // 권한 확인 함수 권한 없으면 권한 요청 화면 표시, 안드로이드만 상관 있음
  _checkPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.contacts.request().isGranted) {}
      Map<Permission, PermissionStatus> statuses =
          await [Permission.location].request();
      print(statuses[Permission.location]);
    }
  }

  //장치 화면에 출력하는 위젯 함수
  list() {
    return ListView.builder(
      itemCount: deviceList.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text(deviceList[index].deviceName),
            subtitle: Text(deviceList[index].peripheral.identifier),
            trailing: Text("${deviceList[index].rssi}"),
            onTap: () {
              // 리스트중 한개를 탭(터치) 하면 해당 디바이스와 연결을 시도한다.
              connect(index);
              print("before remember_device");


            });
      },
    );
  }

  //scan 함수
  void scan() async {
    //디스크 저장 변수
    final device_address = await SharedPreferences.getInstance();
    var remember_device_disk = device_address.getKeys().toList();
    print("ase");
    print(remember_device_disk);
    print("ase");
    if (!_isScanning) {
      deviceList.clear(); //기존 장치 리스트 초기화
      //SCAN 시작
      _bleManager.startPeripheralScan().listen((scanResult) {
        //listen 이벤트 형식으로 장치가 발견되면 해당 루틴을 계속 탐.
        //periphernal.name이 없으면 advertisementData.localName확인 이것도 없다면 unknown으로 표시
        var name = scanResult.peripheral.name ??
            scanResult.advertisementData.localName ??
            "Unknown";
        // 기존에 존재하는 장치면 업데이트
        var findDevice = deviceList.any((element) {
          if (element.peripheral.identifier ==
              scanResult.peripheral.identifier) {
            print(element.peripheral.identifier);

            if (remember_device_disk.contains(element.peripheral.identifier)) {
              var scan_liet =remember_device_disk.where((e) => e == element.peripheral.identifier);

              // connect(element.peripheral.identifier);
              print("device contain");

              connect_rember(scan_liet.single);

              print("finish connect_remember");

              _bleManager.stopPeripheralScan();

              setState(() {
                //BLE 상태가 변경되면 페이지도 갱신
                _isScanning = true;
                setBLEState('Stop Scan');
              });

              return true;

              //connect
            } else {
              element.peripheral = scanResult.peripheral;
              element.advertisementData = scanResult.advertisementData;
              element.rssi = scanResult.rssi;
              return true;
            }
          }
          return false;
        });

        // 새로 발견된 장치면 추가
        if (!findDevice) {
          deviceList.add(BleDeviceItem(name, scanResult.rssi,
              scanResult.peripheral, scanResult.advertisementData));
        }
        //페이지 갱신용
        setState(() {});
      });
      setState(() {
        //BLE 상태가 변경되면 화면도 갱신
        _isScanning = true;
        setBLEState('Scanning');
      });
    } else {
      //스켄중이었으면 스캔 중지
      _bleManager.stopPeripheralScan();
      setState(() {
        //BLE 상태가 변경되면 페이지도 갱신
        _isScanning = false;
        setBLEState('Stop Scan');
      });
    }
  }

  //BLE 연결시 예외 처리를 위한 래핑 함수
  _runWithErrorHandling(runFunction) async {
    try {
      await runFunction();
    } on BleError catch (e) {
      print("BleError caught: ${e.errorCode.value} ${e.reason}");
    } catch (e) {
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      print("${e.runtimeType}: $e");
    }
  }

  // 상태 변경하면서 페이지도 갱신하는 함수
  void setBLEState(txt) {
    setState(() => _statusText = txt);
  }

  connect(index) async {
    print("startin");
    if (_connected) {
      //이미 연 결상태면 연결 해제후 종료
      print("already connecting");
      await _curPeripheral?.disconnectOrCancelConnection();
      setState(() {
        _connected = false;
      });
      return;
    }

    //선택한 장치의 peripheral 값을 가져온다.
    Peripheral peripheral = deviceList[index].peripheral;

    //해당 장치와의 연결상태를 관촬하는 리스너 실행
    peripheral
        .observeConnectionState(
        emitCurrentValue: true, completeOnDisconnect: true)
        .listen((connectionState) {
      print(
          "Peripheral ${peripheral.identifier} connection state is $connectionState");
    });

    _runWithErrorHandling(() async {
      print("_runWithErrorHandling");
      var peripheral_name = peripheral.name;
      //해당 장치와 이미 연결되어 있는지 확인
      bool isConnected = await peripheral.isConnected();
      if (isConnected) {
        print('device is already connected');
        showtoast("이미 $peripheral_name 과 연결되어있습니다.");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CarNumberPage(uid: null, peripheral: peripheral)));

        return;
      }

      //연결 시작!
      await peripheral.connect().then((_) {
        //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다.
        peripheral
            .discoverAllServicesAndCharacteristics()
            .then((_) => peripheral.services())
            .then((services) async {
          print("PRINTING SERVICES for ${peripheral.name}");
          //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
          for (var service in services) {
            print("Found service ${service.uuid}");
            List<Characteristic> characteristics =
            await service.characteristics();
            int index = 0;
            for (var characteristic in characteristics) {
              print(index);
              print("${characteristic.uuid}");
              index++;
            }
          }
          //모든 과정이 마무리되면 연결되었다고 표시

          setState(() {
            _connected = true;
          });
          _bleManager.stopPeripheralScan();
          print("${peripheral.name} has CONNECTED");
          remember_device(deviceList[index].peripheral.identifier);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CarNumberPage(
                      uid: null, peripheral: deviceList[index].peripheral)));
        });
      });
    });
  }

  connect_rember(identifier) async {
    print("please.....");

    if (_connected) {
      //이미 연결상태면 연결 해제후 종료
      print("already connecting");
      await _curPeripheral?.disconnectOrCancelConnection();
      setState(() {
        _connected = false;
      });
      return;
    } else {
      print("asdasd");
      //hihih for문
      int index = 0;


      for (var i in deviceList) {
        if(deviceList[index].peripheral.identifier == identifier){
          //선택한 장치의 peripheral 값을 가져온다.
          Peripheral peripheral = deviceList[index].peripheral;

          //해당 장치와의 연결상태를 관촬하는 리스너 실행
          peripheral
              .observeConnectionState(
              emitCurrentValue: true, completeOnDisconnect: true)
              .listen((connectionState) {
            print(
                "Peripheral ${peripheral.identifier} connection state is $connectionState");
          });

          _runWithErrorHandling(() async {
            print("_runWithErrorHandling");
            var peripheral_name = peripheral.name;
            //해당 장치와 이미 연결되어 있는지 확인
            bool isConnected = await peripheral.isConnected();
            if (isConnected) {
              print('device is already connected');
              showtoast("이미 $peripheral_name 과 연결되어있습니다.");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CarNumberPage(uid: null, peripheral: peripheral)));

              return;
            }

            //연결 시작!
            await peripheral.connect().then((_) {
              //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다.
              peripheral
                  .discoverAllServicesAndCharacteristics()
                  .then((_) => peripheral.services())
                  .then((services) async {
                print("PRINTING SERVICES for ${peripheral.name}");
                //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
                for (var service in services) {
                  print("Found service ${service.uuid}");
                  List<Characteristic> characteristics =
                  await service.characteristics();
                  int index = 0;
                  for (var characteristic in characteristics) {
                    print(index);
                    print("${characteristic.uuid}");
                    index++;
                  }
                }
                //모든 과정이 마무리되면 연결되었다고 표시

                setState(() {
                  _connected = true;
                });
                _bleManager.stopPeripheralScan();
                print("${peripheral.name} has CONNECTED");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarNumberPage(
                            uid: null, peripheral: deviceList[index].peripheral)));
              });
            });
          });

        }else{
          print(index);
          index++;
        }

      }


      print("hoowowo");
    }
  }












  Future<void> remember_device(String address) async {
    final remember_address = await SharedPreferences.getInstance();
    remember_address.setString(address, address);
    print('remember this device');
    print(remember_address.getString(address));
  }

  //페이지 구성
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.03,
            ),
            Center(
              child: Text(
                "페어링할 기기를 선택해주세요",
                style: TextStyle(
                    fontFamily: "numberfont",
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Expanded(
              flex: 1,
              child: list(), //리스트 출력
            ),
            Container(
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    //scan 버튼
                    onPressed: scan,
                    child: Icon(
                        _isScanning ? Icons.stop : Icons.bluetooth_searching),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("State : "), Text(_statusText),
                  //상태 정보 표시
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
