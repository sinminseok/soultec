import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';


class Calendar_page extends StatefulWidget {
  const Calendar_page({Key? key}) : super(key: key);

  @override
  _Calendar_pageState createState() => _Calendar_pageState();
}

class _Calendar_pageState extends State<Calendar_page> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(focusedDay: DateTime.now(), firstDay: DateTime.utc(2010,10,20), lastDay: DateTime.utc(2040,10,20))
        ],
      ),
    );
  }
}
