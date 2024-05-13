import 'package:poputi/extensions/extensions.dart';

extension DateTimeShortFormatter on DateTime {
  String toShortDate() => '$day ${toMonth()}, ${toWeekday()}';
}
