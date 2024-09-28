import 'package:intl/intl.dart';

final DateFormat _dateParseFormat = DateFormat("yyyy-MM-dd");
final DateFormat _datePrintFormat = DateFormat("MMM d, yyyy");


DateTime dateFromString(String dateSting) {
  return _dateParseFormat.parse(dateSting);
}

String dateToString(DateTime date) {
  return _datePrintFormat.format(date);
}
