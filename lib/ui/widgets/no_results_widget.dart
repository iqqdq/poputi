import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 90.0,
        ),
        child: Text(
          Titles.no_results,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            color: HexColors.gray,
          ),
        ),
      ),
    );
  }
}
