// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

String formatDate(String? dateString) {
  // null / empty
  if (dateString == null || dateString.trim().isEmpty) {
    return '-';
  }

  try {
    DateTime? dateTime;

    if (dateString.contains('-')) {
      // เช่น 2026-01-16
      dateTime = DateTime.tryParse(dateString);
    } else if (dateString.length == 8) {
      // เช่น 20260116
      final year = int.tryParse(dateString.substring(0, 4));
      final month = int.tryParse(dateString.substring(4, 6));
      final day = int.tryParse(dateString.substring(6, 8));

      if (year != null && month != null && day != null) {
        dateTime = DateTime(year, month, day);
      }
    }

    // parse ไม่ได้
    if (dateTime == null) {
      return '-';
    }

    return DateFormat('dd/MM/yyyy').format(dateTime);
  } catch (e) {
    return '-';
  }
}

dateStringToDate(String date) {
  var year = date.substring(0, 4);
  var month = date.substring(4, 6);
  var day = date.substring(6, 8);

  return day + '-' + month + '-' + year;
}
