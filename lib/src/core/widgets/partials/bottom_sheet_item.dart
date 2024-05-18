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
      textStyle: TextStyle(color: item.textColor, fontSize: item.textSize),
    );
  }
}
