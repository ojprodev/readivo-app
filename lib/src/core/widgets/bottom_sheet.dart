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
    double dragHandleHeight = 4.0,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
      ),
      backgroundColor: AppColors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => _container(
            bottomSheetItems: bottomSheetItems,
            child: child,
            height: height,
            topPadding: topPadding,
            showDragHandle: showDragHandle,
            dragHandleHeight: dragHandleHeight,
            context: context,
          ),
        );
      },
    );
  }

  static Widget _container({
    List<BottomSheetItem>? bottomSheetItems,
    double? height,
    Widget? child,
    double? topPadding,
    bool? showDragHandle,
    required double dragHandleHeight,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      height: height ?? MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.only(top: topPadding ?? 0.0),
      margin: child != null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(bottom: 8.0, left: 12.0, right: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showDragHandle ?? true)
            _CustomDragHandle(height: dragHandleHeight),
          if (child != null)
            Expanded(child: child)
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    bottomSheetItems!.length,
                    (index) => BottomSheetItemWidget(
                      item: bottomSheetItems[index],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomDragHandle extends StatelessWidget {
  final double height;

  const _CustomDragHandle({this.height = 4.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 40.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
