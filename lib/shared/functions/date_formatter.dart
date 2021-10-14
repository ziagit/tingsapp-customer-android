import 'package:intl/intl.dart';

String dateFormatter(date) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
  return formattedDate;
}
