import 'package:flutter/material.dart';

class CalendarHelper {
  static final CalendarHelper _instance = CalendarHelper._internal();

  CalendarHelper._internal();

  factory CalendarHelper() {
    return _instance;
  }

  Future<DateTime?> chooseDate(
    BuildContext context, {
    String? title,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    var now = DateTime.now();
    try {
      var first = firstDate ?? DateTime(0);
      var last = lastDate ?? DateTime(10000);
      var date = await showDatePicker(
        context: context,
        firstDate: first,
        lastDate: last,
        initialDate: initialDate ?? now,
      );
      return date;
    } catch (err) {
      return null;
    }
  }
}
