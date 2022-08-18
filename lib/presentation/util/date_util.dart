import 'package:intl/intl.dart';

class MyDateUtils {
  static String fromMillisEpochToTime(int epochMillis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    return DateFormat.jm().format(dt);
  }

  static bool isSameDate(int epochMillis1, int epochMillis2) {
    final dateTime1 = DateTime.fromMillisecondsSinceEpoch(epochMillis1);
    final dateTime2 = DateTime.fromMillisecondsSinceEpoch(epochMillis2);
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  static String toDayEEEE(int epochMillis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    final isThisYear = DateTime.now().year == dt.year;
    if (isThisYear) {
      return DateFormat.MMMEd().format(dt);
    } else {
      return DateFormat.yMMMEd().format(dt);
    }
  }
}
