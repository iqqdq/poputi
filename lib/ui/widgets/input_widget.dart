import 'package:flutter/material.dart';
import 'package:poputi/constants/constants.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Color? textColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? margin;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final bool? removeClearButton;
  final bool isRequiredField;
  final bool? showRequiredField;
  final String? placeholder;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final VoidCallback onFieldSubmitted;

  const InputWidget({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    this.textColor,
    this.keyboardAppearance,
    this.margin,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.removeClearButton,
    required this.isRequiredField,
    this.showRequiredField,
    this.placeholder,
    this.onChanged,
    this.onTap,
    required this.onFieldSubmitted,
    this.maxLines,
    this.maxLength,
  }) : super(key: key);

  @override
  State<InputWidget> createState() => _InputState();
}

class _InputState extends State<InputWidget> {
  @override
  void initState() {
    super.initState();

    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final textFormField = TextFormField(
        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength ?? TextField.noMaxLength,
        keyboardAppearance: widget.keyboardAppearance ?? Brightness.light,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        // inputFormatters: widget.textInputType != null
        //     ? widget.textInputType == TextInputType.phone
        //         ? widget.textEditingController.text
        //                     .replaceAll(RegExp(r'[^0-9]'), '')
        //                     .length >
        //                 10
        //             ? [TextMask(pallet: '+## (###) ###-##-##')]
        //             : [TextMask(pallet: '+# (###) ###-##-##')]
        //         : []
        //     : [],
        focusNode: widget.focusNode,
        controller: widget.textEditingController,
        cursorColor: HexColors.blue,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.sentences,
        style: TextStyle(
          fontSize: 16.0,
          color: HexColors.dark,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          counterText: '',
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: widget.textColor ?? HexColors.gray,
          ),
          suffixIcon: widget.removeClearButton == true
              ? null
              : widget.focusNode.hasFocus &&
                      widget.textEditingController.text.isNotEmpty
                  ? IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () => setState(() {
                        widget.onChanged != null ? widget.onChanged!('') : {};
                        widget.textEditingController.clear();
                      }),
                      icon: Image.asset(
                        'assets/ic_clear.png',
                        width: 20.0,
                        height: 20.0,
                        fit: BoxFit.cover,
                        color: HexColors.blue,
                      ),
                    )
                  : IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.transparent,
                      ),
                    ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
        onTap: () => widget.onTap == null
            ? debugPrint('onTap disabled')
            : widget.onTap!(),
        onChanged: (text) =>
            widget.onChanged == null ? {} : widget.onChanged!(text),
        onFieldSubmitted: (text) => widget.onFieldSubmitted());

    return Container(
      height: 47.0,
      padding: const EdgeInsets.only(left: 12.0, right: 4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
              width: 0.5,
              color: widget.showRequiredField == null
                  ? HexColors.light_gray
                  : widget.showRequiredField == true
                      ? HexColors.red
                      : HexColors.light_gray),
          color: HexColors.light_gray),
      child: textFormField,
    );
  }
}
