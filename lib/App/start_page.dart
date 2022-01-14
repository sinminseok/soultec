import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/Bluetooth/blue_discovery.dart';
import 'package:soultec/App/widgets/bluetooth.dart';
import 'package:soultec/Data/toast.dart';
import '../wrapper.dart';

class Start_page extends StatefulWidget {
  @override
  _Start_pageState createState() => _Start_pageState();
}


class _Start_pageState extends State<Start_page> {
   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }


  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);
    var provider = Provider.of<Bluetooth_Service>(context);
    return SafeArea(
      child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: size.width,
                height: defaultRegisterSize,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/gtbimg.png'),
                        width: 100,
                      ),
                      SizedBox(height: size.height*0.03,),
                      Text(
                        '빠르고 편한 주입',
                        style: TextStyle(fontSize: 19),
                      ),
                      Text(
                        '스마트필 시작.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Image(
                          image: AssetImage('assets/images/mainimg.png'),
                          width: 140,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                      ),
                      Text(
                        "페어링이 시작 됩니다 잠시만 기다려 주십시오.",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16.0))),
                        onPressed: () async {
                          print("HOw");

                          //블루투스 장치 스캔 요청 코드
                          print(await FlutterBluetoothSerial.instance.requestEnable());

                          //device를 가져온다.
                          final BluetoothDevice? selectedDevice = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return DiscoveryPage();
                              },
                            ),
                          );

                          if (selectedDevice != null){
                            print('Discovddery -> selected ' + selectedDevice.address);
                            provider.connect_device(selectedDevice.address);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));

                          } else {
                            print('Discovery -> no device selected');
                            showAlertDialog(context , "연결오류","블루투스 기기를 선택해주세요");
                          }
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                        },
                        //Text("연결",style: TextStyle(fontWeight: FontWeight.bold),),
                        child: Icon(Icons.bluetooth),
                        splashColor: Colors.blue,
                        color: Colors.blue,
                        elevation: 0,

                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
