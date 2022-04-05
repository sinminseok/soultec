import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:soultec/App/Pages/receipt/receipt_detail.dart';
import 'package:soultec/App/widgets/top_widget.dart';
import 'package:soultec/Data/toast.dart';
import 'package:soultec/RestAPI/http_service.dart';
import 'package:soultec/Sound/sound.dart';
import 'package:soultec/constants.dart'; // Date Format 사용시 사용하는 패키지
import 'dart:core';

class Receipt_list extends StatefulWidget {
  List? data_list;
  String? car_number;

  Receipt_list({
    required this.car_number,
    required this.data_list,
    user_id,
  });

  @override
  State<Receipt_list> createState() => _Receipt_list();
}

class _Receipt_list extends State<Receipt_list> {
  TextEditingController _BirthdayController = TextEditingController(
    text: '시간 / 날짜',
  );
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

//조회를 눌렀는지 안눌렀는지 체크할 bool
  bool scan_check = false;

  //날짜 검색후 필터링된 정보 담을 list
  var filter_use_data = [];

//최종 리스트
  List? itembuilder_list = [];

  //날짜 String 쪼개는 함수 ,  서버에서 가져온 날짜 가공
  filter_string(dateTime) {
    String? datetime_string;
    datetime_string = dateTime.substring(0, 4) +
        dateTime.substring(5, 7) +
        dateTime.substring(8, 10) +
        dateTime.substring(11, 13) +
        dateTime.substring(14, 16);
    return int.parse(datetime_string!);
  }

  //이용내역을 최근 날짜부터 정렬해주는 함수
  sort_datetime(data_list) async {
    List<int>? datetime_list = [];
    List<String>? datetime_list_string = [];

    for (var i = 0; i < data_list.length; i++) {
      datetime_list.add(filter_string(data_list[i].dateTime));
    }
    datetime_list.sort();
    var reversed_Date = datetime_list.reversed;
    for (var j = 0; j < reversed_Date.toList().length; j++) {
      datetime_list_string.add(reversed_Date.toList()[j].toString());
    }
    return datetime_list_string;
  }

  //이용내역 리스트 최근날짜 순으로 정렬
  index(data_lsit, sort_list) async {
    var data_reversed = [];
    for (var i = sort_list.length - 1; i >= 0; i--) {
      for (var j = data_lsit.length - 1; j >= 0; j--) {
        String? datetime_string =
            await data_lsit[j]!.dateTime!.substring(0, 4) +
                data_lsit[j]!.dateTime!.substring(5, 7) +
                data_lsit[j]!.dateTime!.substring(8, 10) +
                data_lsit[j]!.dateTime!.substring(11, 13) +
                data_lsit[j]!.dateTime!.substring(14, 16);
        if (sort_list[i] == datetime_string) {
          data_reversed.add(data_lsit![i]);
        }
      }
    }

    setState(() {
      //최근 날짜부터 정렬된 Receipt 객체 리스트 setState후 widget itembuilder에서 사용
      itembuilder_list = data_reversed;
    });
  }

  //검색 필터링 함수( 검색 날짜를 기준으로 필터링)
  scan_day_filiter(date) {
    filter_use_data = [];
    //user_use_data for 문으로 돌려 해당 날짜 필터링
    for (var i = 0; i < itembuilder_list!.length; i++) {
      if (itembuilder_list![i].dateTime.substring(0, 10) == date) {
        filter_use_data.add(itembuilder_list![i]);
      }
    }
    setState(() {
      scan_check = true;
    });

    return filter_use_data;
  }

  //initState에서는 비동기 호출이 안되므로 call 함수에서 비동기 작업을 수행한다.
  call() async {
    //index(사용자 이용 내역 list , 최근 날짜로 정렬된 리스트)
    index(widget.data_list, await sort_datetime(widget.data_list));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }

  @override
  void dispose() {
    super.dispose();
    scan_check = false;
    filter_use_data = [];
    itembuilder_list = [];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String? user_id = Provider.of<Http_services>(context).user_id;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Top_widget(),
              Text(
                "${user_id} -- ${widget.car_number}",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 29,
                  fontFamily: "numberfont",
                ),
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
                        decoration: InputDecoration(
                          hintText: "Enter a message",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_drop_down_sharp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_BirthdayController.text == "시간 / 날짜") {
                        return showtoast("조회할 날짜를 선택해주세요");
                      } else {
                        scan_day_filiter(_BirthdayController.text);
                      }
                    },
                    child: Container(
                        color: Color(0xffcc0000),
                        width: size.width * 0.15,
                        height: size.width * 0.1,
                        child: Image.asset("assets/images/inqure_button.png")),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Stack(
                children: [
                  Container(
                      width: size.width * 1,
                      height: size.height * 0.5,
                      child: Image.asset("assets/images/receipt_list.png")),
                  scan_check
                      ?
                      //조회 했을때 보여주는 widget
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Container(
                              height: size.height * 0.42,
                              width: size.width * 0.95,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: filter_use_data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50, bottom: 10),
                                    child: Container(
                                      color: kPrimaryColor,
                                      width: size.width * 1.2,
                                      height: size.height * 0.07,
                                      child: InkWell(
                                        onTap: () {
                                          //해당 날짜 이용내역 detail navigator => filter_use_data[index]
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Recepit_detail(
                                                          list_Data:
                                                              filter_use_data[
                                                                  index])));
                                        },
                                        child: ListTile(
                                          title: Center(
                                              child: Text(
                                            '${filter_use_data[index].dateTime.substring(0, 4)}년 ${filter_use_data[index].dateTime.substring(5, 7)}월 ${filter_use_data[index].dateTime.substring(8, 10)}일 - ${filter_use_data[index].dateTime.substring(11, 16)}  [${filter_use_data[index].amount}리터]',
                                            style: TextStyle(
                                                fontFamily: "numberfont",
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      //조회하지 않았을때 보여주는 widget
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Container(
                              height: size.height * 0.42,
                              width: size.width * 0.95,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: itembuilder_list!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50, right: 50, bottom: 10),
                                    child: Container(
                                      color: kPrimaryColor,
                                      width: size.width * 1.2,
                                      height: size.height * 0.07,
                                      child: InkWell(
                                        onTap: () {
                                          print(itembuilder_list![index]
                                              .dateTime
                                              .substring(0, 10));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Recepit_detail(
                                                          list_Data:
                                                              itembuilder_list![
                                                                  index])));
                                        },
                                        child: ListTile(
                                          title: Center(
                                              child: Text(
                                            '${itembuilder_list![index].dateTime.substring(0, 4)}년 ${itembuilder_list![index].dateTime.substring(5, 7)}월 ${itembuilder_list![index].dateTime.substring(8, 10)}일 - ${itembuilder_list![index].dateTime.substring(11, 16)}  [${itembuilder_list![index].amount}리터]',
                                            style: TextStyle(
                                                fontFamily: "numberfont",
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              InkWell(
                  onTap: () async {
                    Sound().play_sound("assets/mp3/success.mp3");
                    SystemNavigator.pop();
                  },
                  child: Container(
                      width: size.width * 0.6,
                      height: size.height * 0.07,
                      child: Image.asset("assets/images/finish_button.png"))),
              SizedBox(
                height: size.height * 0.07,
              )
            ],
          ),
        ),
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
