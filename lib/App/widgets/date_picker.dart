//
//
//
// import 'dart:js';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// void showDatePickerPop() {
//   Future<DateTime?> selectedDate = showDatePicker(
//     context: context,
//     initialDate: DateTime.now(), //초기값
//     firstDate: DateTime(2020), //시작일
//     lastDate: DateTime(2022), //마지막일
//     builder: (BuildContext context, Widget? child) {
//       return Theme(
//         data: ThemeData.dark(), //다크 테마
//         child: child!,
//       );
//     },
//   );
//
//   selectedDate.then((dateTime) {
//     Fluttertoast.showToast(
//       msg: dateTime.toString(),
//       toastLength: Toast.LENGTH_LONG,
//       //gravity: ToastGravity.CENTER,  //위치(default 는 아래)
//     );
//   });
// }