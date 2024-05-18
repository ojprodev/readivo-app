import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final Widget? deleteIcon;
  final Color borderColor;
  final double borderWidth;
  final Function()? onDeleted;

  const CustomChip({
    super.key,
    required this.text,
    this.icon,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.deleteIcon,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
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
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
