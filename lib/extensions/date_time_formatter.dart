import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';

extension DateTimeFormatter on DateTime {
  String toDate({required bool showTime}) {
    String localeName = Platform.localeName;

    initializeDateFormatting(
      localeName,
      null,
    );

    String date = '';
    DateTime now = DateTime.now().toLocal();

    bool isToday =
        this.year == now.year && this.month == now.month && this.day == now.day;

    bool isYesterday =
        this.year == now.subtract(const Duration(days: 1)).year &&
            this.month == now.subtract(const Duration(days: 1)).month &&
            this.day == now.subtract(const Duration(days: 1)).day;

    final day = isYesterday
        ? localeName.contains('en')
            ? 'Yesterday'
            : 'Вчера'
        : isToday
            ? localeName.contains('en')
                ? 'Today'
                : 'Сегодня'
            : this.day.toString().length == 1
                ? '0${this.day}'
                : '${this.day}';

    final month =
        this.month.toString().length == 1 ? '0${this.month}' : '${this.month}';

    final year = '${this.year}';

    final hour =
        this.hour.toString().length == 1 ? '0${this.hour}' : '${this.hour}';

    final minute = this.minute.toString().length == 1
        ? '0${this.minute}'
        : '${this.minute}';

    date = isYesterday || isToday
        ? showTime
            ? '$day в $hour:$minute'
            : day
        : showTime
            ? '$day.$month.$year в $hour:$minute'
            : '$day.$month.$year';

    return date;
  }
}
