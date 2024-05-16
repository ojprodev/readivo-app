import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final IconData? startIcon;
  final Function()? onStartIconPress;
  final IconData? endIcon;
  final Function()? onEndIconPress;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final double borderRadius;
  final bool filled;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final Color startIconColor;
  final Color endIconColor;
  final Color textColor;
  final TextStyle? textStyle;
  final EdgeInsets contentPadding;
  final bool dismissibleKeyboard;
  final bool autoFocus;
  final TextInputAction? textInputAction;

  const CustomInputField({
    super.key,
    this.startIcon,
    this.onStartIconPress,
    this.endIcon,
    this.onEndIconPress,
    this.onChanged,
    this.placeholder,
    this.borderRadius = 8.0,
    this.filled = true,
    this.fillColor = Colors.grey,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.startIconColor = Colors.grey,
    this.endIconColor = Colors.grey,
    this.textColor = Colors.black,
    this.textStyle,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 5.0),
    this.dismissibleKeyboard = false,
    this.autoFocus = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          dismissibleKeyboard ? () => FocusScope.of(context).unfocus() : null,
      child: Container(
        height: 36.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: filled ? fillColor : Colors.transparent,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: Row(
          children: [
            if (startIcon != null)
              GestureDetector(
                onTap: onStartIconPress,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    startIcon,
                    color: startIconColor,
                  ),
                ),
              ),
            const SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                autofocus: autoFocus,
                onChanged: onChanged,
                textInputAction: textInputAction,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: contentPadding,
                ),
                style: textStyle ?? TextStyle(color: textColor),
              ),
            ),
            if (endIcon != null)
              GestureDetector(
                onTap: onEndIconPress,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    endIcon,
                    color: endIconColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
