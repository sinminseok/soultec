import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:soultec/Presenter/ble_presenter.dart';
import 'package:soultec/View/Pages/cars/car_number.dart';
import 'package:soultec/View/Pages/start_page.dart';
import 'package:soultec/Presenter/data_controller.dart';


import '../../Utils/constants.dart';
import 'blue_device_tile.dart';

class Blue_scan extends StatefulWidget {
  @override
  State<Blue_scan> createState() => _Blue_scan();
}

class _Blue_scan extends State<Blue_scan> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,

      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);
  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  void initState() {
    //ble scan
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "페어링 할 기기를 선택해주세요.",
                style: TextStyle(fontFamily: "numberfont", fontSize: 24),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) {
                  return Column(
                    children: snapshot.data!
                        .map(
                          (r) => Blue_device_tile(
                            result: r,
                            onTap: (){

                              //처음 페어링 할때 해당 디바이스 기억
                              BLE_CONTROLLER().remember_device(r.device.id);

                              //이후 CarNumber page로 이동
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: CarNumberPage(
                                      )));
                            }
                          ),
                        )
                        .toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
