import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:poputi/ui/ui.dart';

import 'package:poputi/constants/constants.dart';

class TimePickerModalWidget extends StatelessWidget {
  final DateTime initialDateTime;
  final Function(DateTime) onUpdate;

  const TimePickerModalWidget({
    Key? key,
    required this.initialDateTime,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          width: 300.0,
          decoration: BoxDecoration(
            color: HexColors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 16.0),
                  Text(Titles.time,
                      style: TextStyle(
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                        color: HexColors.dark_gray,
                      )),
                  const SizedBox(width: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.0,
                        height: 160.0,
                        child: Stack(
                          children: [
                            Center(
                              child: TimePickerSpinner(
                                time: initialDateTime,
                                normalTextStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    decoration: TextDecoration.none,
                                    color: HexColors.dark.withOpacity(0.2)),
                                highlightedTextStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    decoration: TextDecoration.none,
                                    color: HexColors.dark),
                                spacing: 60.0,
                                itemHeight: 40.0,
                                alignment: Alignment.center,
                                is24HourMode: true,
                                isForce2Digits: true,
                                isShowSeconds: false,
                                onTimeChange: (time) => onUpdate(time),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    decoration: TextDecoration.none,
                                    color: HexColors.dark,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ButtonWidget(
                      title: Titles.add,
                      mainAxisAlignment: MainAxisAlignment.center,
                      color: HexColors.blue,
                      titleColor: HexColors.white,
                      onTap: () => Navigator.pop(context))
                ]),
          ),
        ),
      ),
    );
  }
}
