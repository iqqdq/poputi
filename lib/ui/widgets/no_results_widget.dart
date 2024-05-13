import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class NoResultsWidget extends StatelessWidget {
  const NoResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          Titles.no_results,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16.0,
            color: HexColors.gray,
          ),
        ),
      ),
    );
  }
}
