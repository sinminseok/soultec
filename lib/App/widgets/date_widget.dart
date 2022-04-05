import 'package:intl/intl.dart';

String getToday() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  var strToday = formatter.format(now);
  return strToday;
}
