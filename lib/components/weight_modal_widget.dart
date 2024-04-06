import 'package:flutter/material.dart';
import 'package:poputi/components/button_widget.dart';
import 'package:poputi/constants/hex_colors.dart';
import 'package:poputi/constants/titles.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class WeightModalWidget extends StatefulWidget {
  final double initialWeight;
  final Function(double) onUpdate;

  const WeightModalWidget(
      {Key? key, required this.initialWeight, required this.onUpdate})
      : super(key: key);

  @override
  _WeightModalStateWidget createState() => _WeightModalStateWidget();
}

class _WeightModalStateWidget extends State<WeightModalWidget> {
  late double _weight;

  @override
  void initState() {
    _weight = widget.initialWeight;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FittedBox(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                width: 300.0,
                color: HexColors.white,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(Titles.weight_in_kg,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          color: HexColors.dark,
                        )),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 200.0,
                            height: 160.0,
                            child: WheelChooser.integer(
                                onValueChanged: (i) => _weight = i.toDouble(),
                                maxValue: 200,
                                minValue: 1,
                                initValue: _weight.toInt(),
                                unSelectTextStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  color: HexColors.gray,
                                ),
                                selectTextStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w600,
                                  color: HexColors.dark,
                                ),
                                itemSize: 28.0,
                                step: 1)),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    ButtonWidget(
                        title: Titles.add,
                        mainAxisAlignment: MainAxisAlignment.center,
                        color: HexColors.blue,
                        titleColor: HexColors.white,
                        onTap: () =>
                            {widget.onUpdate(_weight), Navigator.pop(context)})
                  ],
                )))));
  }
}
