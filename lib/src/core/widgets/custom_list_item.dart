import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final Widget? icon;
  final Color iconBackground;
  final String label;
  final Widget? appendIcon;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<BoxShadow>? shadow;

  const CustomListItem({
    super.key,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
    this.icon,
    required this.label,
    this.appendIcon,
    this.iconBackground = Colors.transparent,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
    this.margin = const EdgeInsets.symmetric(vertical: 4.0),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (icon != null) Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: iconBackground,
              ),
              child: Center(
                child: icon!,
              ),
            ),

            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                label,
                style: textStyle ?? const TextStyle(color: Colors.black87),
              ),
            ),
            appendIcon ??
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18.0,
                ),
          ],
        ),
      ),
    );
  }
}
