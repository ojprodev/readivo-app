// bottom_sheet_item.dart

import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/constants/constants.dart';
import 'package:readivo_app/src/core/widgets/custom_list_item.dart';

/// Model for an item in the bottom sheet.
class BottomSheetItem {
  final Widget? icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final Color? textColor;
  final double textSize;
  final Widget? appendIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BottomSheetItem({
    this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.lightGrey,
    this.borderRadius = 6.0,
    this.textColor = Colors.black,
    this.textSize = 16.0,
    this.appendIcon,
    this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    this.margin = const EdgeInsets.symmetric(vertical: 2.0),
  });
}

/// Widget for displaying an item in the bottom sheet.
class BottomSheetItemWidget extends StatelessWidget {
  final BottomSheetItem item;

  const BottomSheetItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListItem(
      onTap: item.onTap,
      backgroundColor: item.backgroundColor,
      borderColor: item.borderColor,
      borderRadius: item.borderRadius,
      icon: item.icon,
      label: item.label,
      appendIcon: item.appendIcon,
      padding: item.padding,
      margin: item.margin,
      textStyle: TextStyle(color: item.textColor, fontSize: item.textSize),
    );
  }
}
