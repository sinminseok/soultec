import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/constants.dart';
import '../../wrapper.dart';
import 'blue_device.dart';


class DiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
  List<BluetoothDiscoveryResult>.empty(growable: true);
  Future<List<String>>? check_result = null;

  bool isDiscovering = false;
  _DiscoveryPage();

  @override
  void initState() {
    super.initState();
    isDiscovering = widget.start;
    if (isDiscovering) {
      print("SSTART");
      print(check_result);
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

  Future<void> connect_device(String address) async{
// Some simplest connection :F
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      connection.input!.listen((Uint8List data) {
        print('Data incoming: ${ascii.decode(data)}');
        connection.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          connection.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    }
    catch (exception) {
      print('Cannot connect, exception occured');
      print(exception);
    }

  }

  void _startDiscovery() async{
    final device_address = await SharedPreferences.getInstance();
    var len = device_address.getKeys().toList();
    print(len.runtimeType);
    print("h");
    print(len);
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            final existingIndex = results.indexWhere(
                    (element) => element.device.address == r.device.address);
            if (existingIndex >= 0)

              results[existingIndex] = r;
            else
              if(len.contains(r.device.address)){
                connect_device(r.device.address);
                String device_adddresss=r.device.address;
                Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
                showAlertDialog(context,"이전에 접속한 주유기로 페어링 되었습니다.","$device_adddresss");
                results.add(r);
                //connect
              }else{
                results.add(r);
              }

          });
        });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }


  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(

      child: Scaffold(
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
            SizedBox(height: size.height*0.02,),
            Text("블루투스와 연결할 기기를 선택해주세요",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            SizedBox(height: size.height*0.03,),
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
                    },
                    onLongPress: () async {
                      try {
                        bool bonded = false;
                        if (device.isBonded) {
                          print('Unbonding from ${device.address}...');
                          await FlutterBluetoothSerial.instance
                              .removeDeviceBondWithAddress(address);
                          print('Unbonding from ${device.address} has succed');
                        } else {
                          print('Bonding with ${device.address}...');
                          bonded = (await FlutterBluetoothSerial.instance
                              .bondDeviceAtAddress(address))!;
                          print(
                              'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                        }
                        setState(() {
                          results[results.indexOf(result)] = BluetoothDiscoveryResult(
                              device: BluetoothDevice(
                                name: device.name ?? '',
                                address: address,
                                type: device.type,
                                bondState: bonded
                                    ? BluetoothBondState.bonded
                                    : BluetoothBondState.none,
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
                                    Navigator.of(context).pop();
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
            )
          ],
        ),
      ),
    );
  }
}