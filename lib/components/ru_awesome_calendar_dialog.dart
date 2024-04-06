// ignore_for_file: unused_element

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

/// A custom date time picker that uses AwesomeCalendar
class RuAwesomeCalendarDialog extends StatefulWidget {
  const RuAwesomeCalendarDialog(
      {Key? key,
      this.initialDate,
      this.selectedDates,
      this.startDate,
      this.endDate,
      this.canToggleRangeSelection = false,
      this.selectionMode = SelectionMode.single,
      this.rangeToggleText = 'Select a date range',
      this.confirmBtnText = 'OK',
      this.cancelBtnText = 'CANCEL',
      this.dayTileBuilder,
      this.weekdayLabels,
      this.title,
      this.onResetTap})
      : super(key: key);

  /// Initial date of the date picker, used to know which month needs to be shown
  final DateTime? initialDate;

  /// The current selected dates
  final List<DateTime>? selectedDates;

  /// First date of the calendar
  final DateTime? startDate;

  /// Last date of the calendar
  final DateTime? endDate;

  /// It will add a toggle to activate/deactivate the range selection mode
  final bool canToggleRangeSelection;

  /// [single, multi, range]
  /// The user can switch between multi and range if you set [canToggleRangeSelection] to true
  final SelectionMode selectionMode;

  /// Text of the range toggle if canToggleRangeSelection is true
  final String rangeToggleText;

  /// Text of the confirm button
  final String confirmBtnText;

  /// Text of the cancel button
  final String cancelBtnText;

  /// The builder to create a day widget
  final DayTileBuilder? dayTileBuilder;

  /// A Widget that will be shown on top of the Dailog as a title
  final Widget? title;

  /// The weekdays widget to show above the calendar
  final Widget? weekdayLabels;

  final VoidCallback? onResetTap;

  @override
  _RuAwesomeCalendarDialogState createState() => _RuAwesomeCalendarDialogState(
      // currentMonth: initialDate,
      // selectedDates: selectedDates,
      // selectionMode: selectionMode,
      );
}

class _RuAwesomeCalendarDialogState extends State<RuAwesomeCalendarDialog> {
  _RuAwesomeCalendarDialogState({
    this.currentMonth,
    this.selectedDates,
    this.selectionMode = SelectionMode.single,
  }) {
    currentMonth ??= DateTime.now();
  }

  List<DateTime>? selectedDates;
  DateTime? currentMonth;
  SelectionMode selectionMode;
  GlobalKey<AwesomeCalendarState> calendarStateKey =
      GlobalKey<AwesomeCalendarState>();

  @override
  void initState() {
    initializeDateFormatting();

    selectedDates = widget.selectedDates;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != null) widget.title!,
              Container(
                color: HexColors.blue,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5.0,
                    top: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          calendarStateKey.currentState!.setCurrentDate(
                              DateTime(
                                  currentMonth!.year, currentMonth!.month - 1));
                        },
                      ),
                      Text(
                          DateFormat.yMMMM('ru')
                              .format(currentMonth!)
                              .toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: HexColors.white,
                          )),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right),
                        color: Colors.white,
                        onPressed: () {
                          calendarStateKey.currentState!.setCurrentDate(
                              DateTime(
                                  currentMonth!.year, currentMonth!.month + 1));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: AwesomeCalendar(
                  key: calendarStateKey,
                  startDate: widget.startDate ?? DateTime.now(),
                  endDate: widget.endDate ??
                      DateTime.now().add(const Duration(days: 365)),
                  selectedSingleDate: currentMonth,
                  selectedDates: selectedDates,
                  selectionMode: selectionMode,
                  onPageSelected: (
                    DateTime? start,
                    DateTime? end,
                  ) =>
                      setState(() => currentMonth = start),
                  dayTileBuilder: widget.dayTileBuilder,
                  weekdayLabels: widget.weekdayLabels,
                ),
              ),
              if (widget.canToggleRangeSelection &&
                  selectionMode != SelectionMode.single)
                ListTile(
                  title: Text(
                    widget.rangeToggleText,
                    style: const TextStyle(fontSize: 13),
                  ),
                  leading: Switch(
                    value: selectionMode == SelectionMode.range,
                    onChanged: (bool value) {
                      setState(() {
                        selectionMode =
                            value ? SelectionMode.range : SelectionMode.multi;
                        selectedDates = <DateTime>[];
                        calendarStateKey.currentState!.selectedDates =
                            selectedDates;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWidget(
                title: widget.cancelBtnText,
                onTap: () => widget.onResetTap == null
                    ? Navigator.pop(context)
                    : {
                        widget.onResetTap!(),
                        Navigator.pop(context),
                      },
                color: HexColors.light_gray),
            const SizedBox(width: 12.0),
            ButtonWidget(
              title: widget.confirmBtnText,
              onTap: () => {
                Navigator.of(context).pop(
                  widget.selectionMode == SelectionMode.single
                      ? calendarStateKey.currentState!.selectedSingleDate
                      : calendarStateKey.currentState!.selectedDates,
                )
              },
              color: HexColors.blue,
              titleColor: HexColors.white,
            ),
          ],
        )
      ],
    );
  }
}

class RuWeekdayLabelsWidget extends StatelessWidget {
  final DateTime monday = DateTime(2020, 01, 06);
  final DateTime tuesday = DateTime(2020, 01, 07);
  final DateTime wednesday = DateTime(2020, 01, 08);
  final DateTime thursday = DateTime(2020, 01, 09);
  final DateTime friday = DateTime(2020, 01, 10);
  final DateTime saturday = DateTime(2020, 01, 11);
  final DateTime sunday = DateTime(2020, 01, 12);

  RuWeekdayLabelsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ruDateFormat = DateFormat.E('ru');

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(_ruDateFormat.format(monday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(tuesday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(wednesday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(thursday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(friday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(saturday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
        Expanded(
          child: Text(_ruDateFormat.format(sunday),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: HexColors.gray,
              )),
        ),
      ],
    );
  }
}
