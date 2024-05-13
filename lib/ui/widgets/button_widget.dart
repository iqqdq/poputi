import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final MainAxisAlignment? mainAxisAlignment;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final Color? color;
  final Color? titleColor;
  final bool? isDisabled;
  final String title;
  final bool? isRequiredField;
  final bool? showRequiredField;
  final VoidCallback onTap;

  const ButtonWidget({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.titleColor,
    this.isDisabled,
    this.mainAxisAlignment,
    this.fontSize,
    this.fontWeight,
    this.isRequiredField,
    this.showRequiredField,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled == null
          ? 1.0
          : isDisabled == true
              ? 0.5
              : 1.0,
      child: IgnorePointer(
        ignoring: isDisabled == null
            ? false
            : isDisabled == true
                ? true
                : false,
        child: Container(
          constraints: const BoxConstraints(minWidth: 72.0),
          height: height ?? 47.0,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 13.0),
            color: color ?? HexColors.light_gray,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(),
              borderRadius: BorderRadius.circular(borderRadius ?? 13.0),
              child: Row(
                mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize ?? 16.0,
                        fontWeight: fontWeight ?? FontWeight.normal,
                        color: titleColor ?? HexColors.gray,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
