// bottom_sheet_item.dart

import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';

/// Model for an item in the bottom sheet.
class BottomSheetItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomSheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Widget for displaying an item in the bottom sheet.
class BottomSheetItemWidget extends StatelessWidget {
  final BottomSheetItem item;

  const BottomSheetItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 18.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 18.0,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.lightGrey,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
