// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter_ble_lib/flutter_ble_lib.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:soultec/App/Pages/cars/car_number.dart';
// import 'package:soultec/Data/toast.dart';
// import 'package:soultec/constants.dart';
// import '../../wrapper.dart';
// import 'blue_item.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class DiscoveryPage extends StatefulWidget {
//   @override
//   _DiscoveryPage createState() => new _DiscoveryPage();
// }
//
// class _DiscoveryPage extends State<DiscoveryPage> {
//
//   //ble 매니저 생성
//   BleManager _bleManager = BleManager();
//
//   bool _isScanning = false;
//   bool _connected = false;
//
//   Peripheral? _curPeripheral;           // 연결된 장치 변수
//   List<BleDeviceItem> deviceList = []; // BLE 장치 리스트 변수
//   String _statusText = '';
//
//
//   @override
//   void initState() {
//     init();
//     scan();
//     super.initState();
//   }
//
//   @override
//   void dispose(){
//     // _curPeripheral = null;
//     // deviceList.clear();
//     // _isScanning = false;
//     // _connected = false;
//     // _bleManager.destroyClient();
//
//     super.dispose();
//   }
//
//   // BLE 초기화 함수
//   void init() async {
//     //ble 매니저 생성
//     await _bleManager.createClient(
//         restoreStateIdentifier: "example-restore-state-identifier",
//         restoreStateAction: (peripherals) {
//           peripherals.forEach((peripheral) {
//             print("Restored peripheral: ${peripheral.name}");
//           });
//         })
//         .catchError((e) => print("Couldn't create BLE client  $e"))
//         .then((_) => _checkPermissions())  //매니저 생성되면 권한 확인
//         .catchError((e) => print("Permission check error $e"));
//   }
//
//   // 권한 확인 함수 권한 없으면 권한 요청 화면 표시, 안드로이드만 상관 있음
//   _checkPermissions() async {
//     if (Platform.isAndroid) {
//       if (await Permission.contacts.request().isGranted) {
//       }
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.location
//       ].request();
//       print(statuses[Permission.location]);
//     }
//   }
//
//   //장치 화면에 출력하는 위젯 함수
//   list() {
//     return ListView.builder(
//       itemCount: deviceList.length,
//       itemBuilder: (context, index) {
//
//         return ListTile(
//             title: Text(deviceList[index].deviceName),
//             subtitle: Text(deviceList[index].peripheral.identifier),
//             trailing: Text("${deviceList[index].rssi}"),
//             onTap: () {  // 리스트중 한개를 탭(터치) 하면 해당 디바이스와 연결을 시도한다.
//               connect(index);
//               remember_device(deviceList[index].peripheral.identifier);
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CarNumberPage(uid: null,peripheral:deviceList[index].peripheral)));
//             }
//         );
//       },
//     );
//   }
//
//   //scan 함수
//   void scan() async {
//     final device_address = await SharedPreferences.getInstance();
//     var len = device_address.getKeys().toList();
//
//     if(!_isScanning) {
//       deviceList.clear(); //기존 장치 리스트 초기화
//       _bleManager.startPeripheralScan().listen((scanResult) {
//         //listen 이벤트 형식으로 장치가 발견되면 해당 루틴을 계속 탐.
//         //periphernal.name이 없으면 advertisementData.localName확인 이것도 없다면 unknown으로 표시
//
//         var name = scanResult.peripheral.name ?? scanResult.advertisementData.localName ?? "Unknown";
//         // 기존에 존재하는 장치면 업데이트
//         var findDevice = deviceList.any((element) {
//           if(element.peripheral.identifier == scanResult.peripheral.identifier)
//           {
//
//             if(len.contains(element.peripheral.identifier)){
//              // connect(element.peripheral.identifier);
//               print("device contain");
//
//               element.peripheral = scanResult.peripheral;
//               element.advertisementData = scanResult.advertisementData;
//               element.rssi = scanResult.rssi;
//               print("start connect remebeer");
//               connect_remember(element.peripheral.identifier);
//               print("finish connect_remember");
//               _bleManager.stopPeripheralScan();
//
//               setState(() { //BLE 상태가 변경되면 페이지도 갱신
//                 _isScanning = false;
//                 setBLEState('Stop Scan');
//               });
//               var con_device = element.peripheral.name;
//               Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper(peripheral:element.peripheral )));
//               showAlertDialog(context,"이전에 접속한 주유기로 페어링 되었습니다.","$con_device");
//               return true;
//
//               //connect
//             }else{
//               element.peripheral = scanResult.peripheral;
//               element.advertisementData = scanResult.advertisementData;
//               element.rssi = scanResult.rssi;
//               return true;
//             }
//
//               element.peripheral = scanResult.peripheral;
//               element.advertisementData = scanResult.advertisementData;
//               element.rssi = scanResult.rssi;
//               return true;
//           }
//           return false;
//         });
//         // 새로 발견된 장치면 추가
//         if(!findDevice) {
//           deviceList.add(BleDeviceItem(name, scanResult.rssi, scanResult.peripheral, scanResult.advertisementData));
//         }
//         //페이지 갱신용
//         setState((){});
//       });
//       setState(() { //BLE 상태가 변경되면 화면도 갱신
//         _isScanning = true;
//         setBLEState('Scanning');
//       });
//     }
//     else {
//       //스켄중이었으면 스캔 중지
//       _bleManager.stopPeripheralScan();
//       setState(() { //BLE 상태가 변경되면 페이지도 갱신
//         _isScanning = false;
//         setBLEState('Stop Scan');
//       });
//     }
//   }
//
//
//   Future<void> remember_device(String address)  async{
//     final remember_address = await SharedPreferences.getInstance();
//     remember_address.setString(address, address);
//     print('remember this device');
//     print(remember_address.getString(address));
//
//   }
//   //
//   // //디바이스 기억 블루투스 장치 조회 함수
//   // Future<List<String>> check_device()async{
//   //   final device_address = await SharedPreferences.getInstance();
//   //   var len = device_address.getKeys().toList();
//   //   print(device_address.getKeys().toList());
//   //   for(var i  in len){
//   //     print(i);
//   //   }
//   //   return len;
//   // }
//
//   //BLE 연결시 예외 처리를 위한 래핑 함수
//   _runWithErrorHandling(runFunction) async {
//     try {
//       await runFunction();
//     } on BleError catch (e) {
//       print("BleError caught: ${e.errorCode.value} ${e.reason}");
//     } catch (e) {
//       if (e is Error) {
//         debugPrintStack(stackTrace: e.stackTrace);
//       }
//       print("${e.runtimeType}: $e");
//     }
//   }
//
//   //이전에 연결한 디바이스가 있을경우  커넥션 해주는 함수
//   connect_remember(identifier) async {
//
//     if(_connected) {  //이미 연결상태면 연결 해제후 종료
//       await _curPeripheral?.disconnectOrCancelConnection();
//       return;
//     }
//     print('hi');
//
//     //선택한 장치의 peripheral 값을 가져온다.
//
//     for(var i in deviceList){
//       int index = 0;
//       print(index);
//       if(deviceList[index].peripheral.identifier == identifier){
//         Peripheral peripheral = deviceList[index].peripheral;
//         peripheral.observeConnectionState(emitCurrentValue: true, completeOnDisconnect: true)
//             .listen((connectionState) async {
//           print("Peripheral ${peripheral.identifier} connection state is $connectionState");
//           await peripheral.connect();
//           bool connected = await peripheral.isConnected();
//           print("minseok");
//           print(connected);
//         });
//       }else{
//         index++;
//       }
//     }
//
//
//
//   }
//
//
//   //연결 함수
//   connect(index) async {
//     if(_connected) {  //이미 연결상태면 연결 해제후 종료
//       await _curPeripheral?.disconnectOrCancelConnection();
//       return;
//     }
//
//     //선택한 장치의 peripheral 값을 가져온다.
//     Peripheral peripheral = deviceList[index].peripheral;
//
//     //해당 장치와의 연결상태를 관촬하는 리스너 실행
//     peripheral.observeConnectionState(emitCurrentValue: true)
//         .listen((connectionState) {
//       // 연결상태가 변경되면 해당 루틴을 탐.
//       switch(connectionState) {
//         case PeripheralConnectionState.connected: {
//           remember_device(peripheral.identifier);//연결됨
//           _curPeripheral = peripheral;
//           setBLEState('connected');
//         }
//         break;
//         case PeripheralConnectionState.connecting: { setBLEState('connecting'); }//연결중
//         break;
//         case PeripheralConnectionState.disconnected: { //해제됨
//           _connected=false;
//           print("${peripheral.name} has DISCONNECTED");
//           setBLEState('disconnected');
//         }
//         break;
//         case PeripheralConnectionState.disconnecting: { setBLEState('disconnecting');}//해제중
//         break;
//         default:{//알수없음...
//           print("unkown connection state is: \n $connectionState");
//         }
//         break;
//       }
//     });
//
//     _runWithErrorHandling(() async {
//       //해당 장치와 이미 연결되어 있는지 확인
//       bool isConnected = await peripheral.isConnected();
//       if(isConnected) {
//         print('device is already connected');
//         //이미 연결되어 있기때문에 무시하고 종료..
//         return;
//       }
//
//       //연결 시작
//       await peripheral.connect().then((_) {
//         //연결이 되면 장치의 모든 서비스와 캐릭터리스틱을 검색한다 , 여기서 연결된 서비스,캐릭터리스틱을 통해 uuid 랑 서버 캐릭터리스틱을 이용해 해당 디바이스와 데이터를 송수신 할수있다.
//         peripheral.discoverAllServicesAndCharacteristics()
//             .then((_) => peripheral.services())
//             .then((services) async {
//           print("PRINTING SERVICES for ${peripheral.name}");
//           //각각의 서비스의 하위 캐릭터리스틱 정보를 디버깅창에 표시한다.
//           for(var service in services) {
//             print("Found service ${service.characteristics()}");
//             print("Found service ${service.uuid}");
//             List<Characteristic> characteristics = await service.characteristics();
//             for( var characteristic in characteristics ) {
//               print("${characteristic.uuid}");
//             }
//           }
//           //모든 과정이 마무리되면 연결되었다고 표시
//           _connected = true;
//           print("${peripheral.name} has CONNECTED");
//         });
//       });
//     });
//   }
//
//   // 상태 변경하면서 페이지도 갱신하는 함수
//   void setBLEState(txt){
//     setState(() => _statusText = txt);
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: size.height*0.02,),
//             Text("블루투스와 연결할 기기를 선택해주세요",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//             SizedBox(height: size.height*0.03,),
//             Expanded(
//               flex: 1,
//               child: list(), //리스트 출력
//             ),
//
//             Center(
//               child: Container(
//                 child: Row(
//                   children: <Widget>[
//                     RaisedButton( //scan 버튼
//                       onPressed: scan,
//                       child: Icon(_isScanning?Icons.stop:Icons.bluetooth_searching),
//                     ),
//                     SizedBox(width: 10,),
//                     Text("현재상태 : "), Text(_statusText), //상태 정보 표시
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
