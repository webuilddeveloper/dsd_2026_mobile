// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime;

  if (dateString.contains('-')) {
    // format: 2026-01-16
    dateTime = DateTime.parse(dateString);
  } else {
    // format: 20260116
    dateTime = DateTime(
      int.parse(dateString.substring(0, 4)),
      int.parse(dateString.substring(4, 6)),
      int.parse(dateString.substring(6, 8)),
    );
  }

  return DateFormat('dd/MM/yyyy').format(dateTime);
}
