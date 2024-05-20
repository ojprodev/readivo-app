import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double borderRadius;
  final Widget? deleteIcon;
  final Color borderColor;
  final double borderWidth;
  final Function()? onDeleted;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const CustomChip({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.deleteIcon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
    this.onDeleted,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelStyle: textStyle,
      padding: padding,
      label: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColors.grey,
        ),
      ),
      avatar: icon != null
          ? Icon(
              icon,
              color: iconColor,
              size: 22,
            )
          : null,
      side: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      deleteIcon: deleteIcon,
      onDeleted: onDeleted,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsetsDirectional.only(end: 2.0),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
