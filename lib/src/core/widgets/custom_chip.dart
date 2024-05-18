import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';

Widget buildCustomChip({
  required String text,
  IconData? icon,
  Color? iconColor,
  Color? textColor,
  Color? backgroundColor,
  double? borderRadius,
}) {
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
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 20.0),
      side: const BorderSide(color: Colors.transparent),
    ),
  );
}
