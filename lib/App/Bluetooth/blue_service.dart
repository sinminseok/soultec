


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Bluetooth extends StatefulWidget {
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];

  @override
  _BluetoothState createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  // BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBlue flutterBlue = FlutterBlue.instance;



  void blue_scan()async{
    await flutterBlue.startScan(timeout: Duration(seconds: 4));
    _addDeviceTolist(final BluetoothDevice device) {
      if (!widget.devicesList.contains(device)) {
        setState(() {
          widget.devicesList.add(device);
        });
      }
    }

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

// Stop scanning
  }


  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;


  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name == '' ? '(unknown device)' : device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();

    // Get current state
    // FlutterBluetoothSerial.instance.state.then((state) {
    //   setState(() {
    //     _bluetoothState = state;
    //   });
    // });
    //
    // Future.doWhile(() async {
    //   // Wait if adapter not enabled
    //   if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
    //     return false;
    //   }
    //   await Future.delayed(Duration(milliseconds: 0xDD));
    //   return true;
    // }).then((_) {
    //   // Update the address field
    //   FlutterBluetoothSerial.instance.address.then((address) {
    //     setState(() {
    //       _address = address!;
    //     });
    //   });
    // });
    //
    // FlutterBluetoothSerial.instance.name.then((name) {
    //   setState(() {
    //     _name = name!;
    //   });
    // });
    //
    // // Listen for futher state changes
    // FlutterBluetoothSerial.instance
    //     .onStateChanged()
    //     .listen((BluetoothState state) {
    //   setState(() {
    //     _bluetoothState = state;
    //
    //     // Discoverable mode is disabled when Bluetooth gets disabled
    //     _discoverableTimeoutTimer = null;
    //     _discoverableTimeoutSecondsLeft = 0;
    //   });
    // });
  }

//   void connect_device(String address) async{
// // Some simplest connection :F
//     try {
//       BluetoothConnection connection = await BluetoothConnection.toAddress(address);
//       print('Connected to the device');
//       connection.input!.listen((Uint8List data) {
//         print('Data incoming: ${ascii.decode(data)}');
//         connection.output.add(data); // Sending data
//
//         if (ascii.decode(data).contains('!')) {
//           connection.finish(); // Closing connection
//           print('Disconnecting by local host');
//         }
//       }).onDone(() {
//         print('Disconnected by remote request');
//       });
//     }
//     catch (exception) {
//       print('Cannot connect, exception occured');
//       print(exception);
//     }
//   }

  // @override
  // void dispose() {
  //   FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
  //   _discoverableTimeoutTimer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double defaultRegisterSize = size.height - (size.height * 0.1);
    return Scaffold(
      appBar: AppBar(),
      body: _buildListViewOfDevices()
    );
  }
}
