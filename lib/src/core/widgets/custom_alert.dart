import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final Widget? actions;
  final Color backgroundColor;
  final ShapeBorder shape;
  final EdgeInsets insetPadding;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle titleTextStyle;
  final TextAlign titleTextAlign;
  final Widget? leadingIcon;
  final bool closeButton;
  final EdgeInsets actionsPadding;
  final bool? showTitle;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.backgroundColor = Colors.white,
    this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    this.titlePadding = const EdgeInsets.all(6.0),
    this.contentPadding = const EdgeInsets.all(16.0),
    this.actionsPadding = const EdgeInsets.all(4.0),
    this.titleTextStyle = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.black),
    this.titleTextAlign = TextAlign.center,
    this.leadingIcon,
    this.closeButton = false,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: shape,
      insetPadding: insetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: titlePadding,
            child: Row(
              children: [
                if (leadingIcon != null) leadingIcon!,
                if (closeButton)
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                if (showTitle == true)
                  Expanded(
                    child: Text(
                      title,
                      textAlign: titleTextAlign,
                      style: titleTextStyle,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: contentPadding,
            child: content,
          ),
          Container(
            padding: actionsPadding,
            child: actions,
          ),
        ],
      ),
    );
  }
}
