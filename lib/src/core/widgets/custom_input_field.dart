import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';

class CustomInputField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final IconData? startIcon;
  final Function()? onStartIconPress;
  final IconData? endIcon;
  final Function()? onEndIconPress;
  final ValueChanged<String>? onSubmit;
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
  final String? keyboardType;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? suffix;

  const CustomInputField({
    super.key,
    this.label,
    this.controller,
    this.startIcon,
    this.onStartIconPress,
    this.endIcon,
    this.onEndIconPress,
    this.onChanged,
    this.onSubmit,
    this.placeholder,
    this.borderRadius = 8.0,
    this.filled = true,
    this.fillColor = Colors.white,
    this.borderColor = AppColors.lightGrey,
    this.borderWidth = 1.0,
    this.startIconColor = Colors.grey,
    this.endIconColor = Colors.grey,
    this.textColor = Colors.black87,
    this.textStyle,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
    this.dismissibleKeyboard = false,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          dismissibleKeyboard ? () => FocusScope.of(context).unfocus() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                label!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
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
                if (prefix != null) prefix!,
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
                    controller: controller,
                    autofocus: autoFocus,
                    onChanged: onChanged,
                    onSubmitted: onSubmit,
                    textInputAction: textInputAction,
                    keyboardType: _getKeyboardType(keyboardType),
                    maxLines: maxLines,
                    minLines: minLines,
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
                if (suffix != null) suffix!,
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(String? type) {
    switch (type) {
      case 'number':
        return TextInputType.number;
      case 'date':
        return TextInputType.datetime;
      case 'textarea':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}
