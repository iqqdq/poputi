import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class CityTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CityTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: 6.0,
            ),
            child: Text(title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: HexColors.dark,
                )),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 6.0,
              left: 20.0,
            ),
            height: 0.5,
            color: HexColors.gray,
          ),
        ]),
      ),
    );
  }
}
