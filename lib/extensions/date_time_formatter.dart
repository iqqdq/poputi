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

    DateTime local = toLocal();
    DateTime now = DateTime.now().toLocal();

    bool isYesterday = local.year == now.year &&
        local.month == now.month &&
        local.day == now.subtract(const Duration(days: 1)).day;

    bool isToday = local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;

    bool isTomorrow = local.year == now.year &&
        local.month == now.month &&
        local.day == now.add(const Duration(days: 1)).day;

    final day = isYesterday
        ? localeName.contains('en')
            ? 'Yesterday'
            : 'Вчера'
        : isToday
            ? localeName.contains('en')
                ? 'Today'
                : 'Сегодня'
            : isTomorrow
                ? localeName.contains('en')
                    ? 'Tomorrow'
                    : 'Завтра'
                : local.day.toString().length == 1
                    ? '0${local.day}'
                    : '${local.day}';

    final month = local.month.toString().length == 1
        ? '0${local.month}'
        : '${local.month}';

    final year = '${local.year}';

    final hour =
        local.hour.toString().length == 1 ? '0${local.hour}' : '${local.hour}';

    final minute = local.minute.toString().length == 1
        ? '0${local.minute}'
        : '${local.minute}';

    date = isYesterday || isToday || isTomorrow
        ? showTime
            ? '$day в $hour:$minute'
            : day
        : showTime
            ? '$day.$month.$year, $hour:$minute'
            : '$day.$month.$year';

    return date;
  }
}
