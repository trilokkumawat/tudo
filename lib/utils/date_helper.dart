import 'package:intl/intl.dart';

class DateHelper {
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

    return "$dayName ${dayNumber}${suffix(now.day)} $monthName";
  }
}
