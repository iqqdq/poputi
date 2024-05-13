import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class AddTripButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AddTripButtonWidget({
    super.key,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Material(
          color: HexColors.black,
          borderRadius: BorderRadius.circular(16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: HexColors.white,
                    size: 24.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    Titles.trip,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: HexColors.white,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => onTap(),
          ),
        ),
      ),
    );
  }
}
