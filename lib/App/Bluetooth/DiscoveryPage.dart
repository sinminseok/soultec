import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:soultec/Account/login_main.dart';
import 'package:soultec/constants.dart';
import 'package:soultec/wrapper.dart';

import 'BluetoothDeviceListEntry.dart';

class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  _DiscoveryPage();

  @override
  void initState() {
    super.initState();
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere((element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else
          results.add(r);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.2,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.2 - 27,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      )),
                ),
                Center(
                  child: Image(
                    image: AssetImage('assets/images/cartoonimg.png'),
                    width: 140,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "블루투스와 연결할 기기를 선택해주세요",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, index) {
                BluetoothDiscoveryResult result = results[index];
                final device = result.device;
                final address = device.address;
                return BluetoothDeviceListEntry(
                  device: device,
                  rssi: result.rssi,
                  onTap: () {
                    Navigator.of(context).pop(result.device);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                  },
                  onLongPress: () async {
                    try {
                      bool bonded = false;
                      if (device.isBonded) {
                        print('Unbonding from ${device.address}...');
                        await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(address);
                        print('Unbonding from ${device.address} has succed');
                      } else {
                        print('Bonding with ${device.address}...');
                        bonded = (await FlutterBluetoothSerial.instance.bondDeviceAtAddress(address))!;
                        print('Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                      }
                      setState(() {
                        results[results.indexOf(result)] = BluetoothDiscoveryResult(
                            device: BluetoothDevice(
                              name: device.name ?? '',
                              address: address,
                              type: device.type,
                              bondState: bonded ? BluetoothBondState.bonded : BluetoothBondState.none,
                            ),
                            rssi: result.rssi);
                      });
                    } catch (ex) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error occured while bonding'),
                            content: Text("${ex.toString()}"),
                            actions: <Widget>[
                              new TextButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
