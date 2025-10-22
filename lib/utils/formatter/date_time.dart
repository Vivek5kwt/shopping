import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatChatDateTimeSimple(DateTime messageTime) {
    DateTime now = DateTime.now();

    Duration difference = now.difference(messageTime);
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime messageDate = DateTime(
      messageTime.year,
      messageTime.month,
      messageTime.day,
    );

    if (difference.inHours < 24 && messageDate == today) {
      return DateFormat('HH:mm').format(messageTime); // 12:23
    } else if (messageDate == yesterday) {
      return "Yesterday";
    } else {
      return DateFormat('M/d/yyyy').format(messageTime); // 9/9/2025
    }
  }
}
