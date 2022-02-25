import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:soultec/App/Pages/cars/car_number.dart';
import 'package:soultec/Data/Object/user_object.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';

import 'blue_device_tile.dart';

class Blue_scan extends StatefulWidget {
  User_token? user_token;
  String? user_id;

  Blue_scan({required this.user_token, required this.user_id});

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
              return FindDevicesScreen(
                user_token: widget.user_token,
                user_id: widget.user_id,
              );
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
    return Scaffold(
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
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  User_token? user_token;
  String? user_id;

  FindDevicesScreen({required this.user_token, required this.user_id});

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
              builder: (c, snapshot) => Column(
                children: snapshot.data!
                    .map(
                      (r) => Blue_device_tile(
                        result: r,
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          r.device.connect();
                          showtoast("페어링 되었습니다 ${r.device.id}");
                          return CarNumberPage(
                              user_token: widget.user_token,
                              user_id: widget.user_id,
                              device: r.device);
                        })),
                        user_id: widget.user_id,
                        user: widget.user_token,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}