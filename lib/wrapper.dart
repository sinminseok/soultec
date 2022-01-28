import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:provider/provider.dart';
import 'Account/login_page.dart';
import 'App/Pages/cars/car_number.dart';
import 'Data/database.dart';



class Wrapper extends StatelessWidget {
  final Peripheral? peripheral;

  Wrapper({required this.peripheral});


  @override
  Widget build(BuildContext context) {

      return CarNumberPage(uid: null,peripheral : peripheral);
    }
}