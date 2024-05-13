import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:poputi/constants/constants.dart';

class TimePickerWidget extends StatelessWidget {
  final DateTime dateTime;
  final Function(DateTime) didReturnValue;

  const TimePickerWidget({
    Key? key,
    required this.dateTime,
    required this.didReturnValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 96.0,
        height: 47.0,
        decoration: BoxDecoration(
          color: HexColors.light_gray,
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Stack(children: [
          Center(
            child: TimePickerSpinner(
              time: dateTime,
              normalTextStyle: TextStyle(
                  fontSize: 16.0, color: HexColors.dark.withOpacity(0.2)),
              highlightedTextStyle:
                  TextStyle(fontSize: 16.0, color: HexColors.dark),
              spacing: 0.0,
              itemHeight: 16.0,
              alignment: Alignment.center,
              is24HourMode: true,
              isForce2Digits: true,
              isShowSeconds: false,
              onTimeChange: (time) => didReturnValue(time),
            ),
          ),
          Center(
            child: Text(
              ':',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: HexColors.dark.withOpacity(0.4),
              ),
            ),
          ),
        ]),
      )
    ]);
  }
}