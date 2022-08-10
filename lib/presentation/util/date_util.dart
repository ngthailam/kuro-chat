import 'package:intl/intl.dart';

DateFormat formatTime12h = DateFormat('HH:mm a');

class MyDateUtils {
  static String fromMillisEpochToTime(int millisEpoch) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millisEpoch * 1000);
    return formatTime12h.format(dt);
  }
}
