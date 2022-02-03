import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:soultec/constants.dart'; // Date Format 사용시 사용하는 패키지
import 'package:http/http.dart' as http;


class Receipt_list extends StatefulWidget {
  @override
  State<Receipt_list> createState() => _Receipt_list();
}

class _Receipt_list extends State<Receipt_list> {
  TextEditingController _BirthdayController =
      TextEditingController(text: '시간 / 날짜');

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Text(
                      "충전관리 솔루션",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "스마트필",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Image(
                    image: AssetImage('assets/images/mainimg.png'),
                    width: 60,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              "0123-45gj6789",
              style: TextStyle(
                  color: Colors.red, fontSize: 29, fontFamily: "numberfont"),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _selectDate();
                  },
                  child: Container(
                    color: Colors.white,
                    width: size.width * 0.6,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      controller: _BirthdayController,
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.redAccent,
                    width: size.width * 0.15,
                    height: size.width * 0.1,
                    child: Center(
                        child: Text(
                      "조회",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height*0.05,
            ),
            // Container(
            //   color: Colors.white,
            //   width: size.width*0.8,
            //   height: size.height*0.4,
            //   child: ListView.builder(
            //     padding: const EdgeInsets.all(8),
            //     itemCount: people.length + 1,
            //     itemBuilder: (BuildContext context, int index) {
            //       if (index == 0) return HeaderTile();
            //       return PersonTile(people[index-1]);
            //     },
            //   );
            // ),
          ],
        ),

    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        // DateTime tempPickedDate;
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    CupertinoButton(
                      child: Text('완료'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _BirthdayController.text = pickedDate.toString();
        convertDateTimeDisplay(_BirthdayController.text);
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return _BirthdayController.text = serverFormater.format(displayDate);
  }
}