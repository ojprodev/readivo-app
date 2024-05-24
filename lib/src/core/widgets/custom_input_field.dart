import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';

import 'custom_text.dart';

class CustomInputField extends StatefulWidget {
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
  final TextStyle? labelTextStyle;
  final String? Function(String?)? validator;

  const CustomInputField({
    Key? key,
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
    this.labelTextStyle = const TextStyle(
      color: Colors.black54,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.dismissibleKeyboard = false,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefix,
    this.suffix,
    this.validator,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  TextEditingController? _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    setState(() {
        _errorText = widget.validator?.call(value);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.dismissibleKeyboard
          ? () => FocusScope.of(context).unfocus()
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.label!,
                style: widget.labelTextStyle,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.filled ? widget.fillColor : Colors.transparent,
              border: Border.all(
                color: _errorText != null ? AppColors.lightRed :widget.borderColor,
                width: widget.borderWidth,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefix != null) widget.prefix!,
                if (widget.startIcon != null)
                  GestureDetector(
                    onTap: widget.onStartIconPress,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        widget.startIcon,
                        color: widget.startIconColor,
                      ),
                    ),
                  ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: widget.autoFocus,
                    onChanged: _handleChanged,
                    onSubmitted: widget.onSubmit,
                    textInputAction: widget.textInputAction,
                    keyboardType: _getKeyboardType(widget.keyboardType),
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: widget.contentPadding,
                    ),
                    style:
                        widget.textStyle ?? TextStyle(color: widget.textColor),
                  ),
                ),
                if (widget.endIcon != null)
                  GestureDetector(
                    onTap: widget.onEndIconPress,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        widget.endIcon,
                        color: widget.endIconColor,
                      ),
                    ),
                  ),
                if (widget.suffix != null) widget.suffix!,
              ],
            ),
          ),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: CustomText(_errorText!, color: Colors.red, fontSize: 12),
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
