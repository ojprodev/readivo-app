library utils;

import 'package:intl/intl.dart';

String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
  final DateFormat formatter = DateFormat(format);
  return formatter.format(date);
}

double parseRatingsAverage(String rating) {
  return double.tryParse(
      double.tryParse(rating)
          ?.toStringAsFixed(2) ??
          '0.0') ??
      0.0;
}