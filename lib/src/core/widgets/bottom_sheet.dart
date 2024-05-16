// bottom_sheet_widget.dart
import 'package:flutter/material.dart';
import 'package:readivo_app/src/core/constants/colors.dart';
import 'package:readivo_app/src/core/widgets/partials/bottom_sheet_item.dart';

/// Widget for displaying a bottom sheet with options.
class CustomBottomSheet {
  static void show({
    required BuildContext context,
    List<BottomSheetItem>? bottomSheetItems,
    double? height,
    Widget? child,
    bool? showDragHandle = true,
    double? topPadding,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: showDragHandle,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      backgroundColor: AppColors.white,
      builder: (BuildContext context) {
        return _container(
          bottomSheetItems: bottomSheetItems,
          child: child,
          height: height,
          topPadding: topPadding,
        );
      },
    );
  }

  static Widget _container({
    List<BottomSheetItem>? bottomSheetItems,
    double? height,
    Widget? child,
    double? topPadding,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      margin: child != null ? const EdgeInsets.all(0) : const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.white,
      ),
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          bottomSheetItems!.length,
              (index) => BottomSheetItemWidget(item: bottomSheetItems[index]),
        ),
      ),
    );
  }
}