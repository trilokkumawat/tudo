import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getFormattedTodayDate() {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dayNumber = DateFormat('d').format(now);
    final monthName = DateFormat('MMMM').format(now);

    String suffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    return "$dayName $dayNumber${suffix(now.day)} $monthName";
  }

  static String formatTime(int hour, int minute) {
    final dt = DateTime(0, 0, 0, hour, minute);
    return DateFormat('hh:mm a').format(dt); // example: 04:35 PM
  }

  static String formatDate(String isoDateString) {
    final dateTime = DateTime.parse(isoDateString);
    return DateFormat("MMM dd, yyyy").format(dateTime);
  }

  static TimeOfDay parseTimeOfDay(String timeString) {
    final format = DateFormat('hh:mm a'); // ex: 04:35 PM
    final DateTime dt = format.parse(timeString);
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }
}
