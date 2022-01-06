import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:soultec/App/Bluetooth/DiscoveryPage.dart';
import '../../constants.dart';
import 'package:nfc_manager/nfc_manager.dart';

class Start_page extends StatefulWidget {
  const Start_page({Key? key}) : super(key: key);

  @override
  _Start_pageState createState() => _Start_pageState();
}

class _Start_pageState extends State<Start_page> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: defaultRegisterSize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    image: AssetImage('assets/images/cartoonimg.png'),
                    width: 140,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                Text(
                  "페어링이 시작 됩니다 잠시만 기다려 주십시오.a",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: size.height * 0.08,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  onPressed: () async {
                    // final BluetoothDevice? selectedDevice =
                    //     await Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return DiscoveryPage();
                    //     },
                    //   ),
                    // );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));

                    // if (selectedDevice != null) {
                    //   print('Discovery -> selected ' + selectedDevice.address);
                    // } else {
                    //   print('Discovery -> no device selected');
                    // }
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  //Text("연결",style: TextStyle(fontWeight: FontWeight.bold),),
                  child: Icon(Icons.bluetooth),
                  splashColor: Colors.blue,
                  color: Colors.blue,
                  elevation: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
