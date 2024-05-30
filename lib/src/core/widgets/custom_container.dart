import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? boxDecoration;
  final Color? color;
  final double borderRadius;
  final BoxShadow? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;
  final AlignmentGeometry? alignment;
  final Widget? child;
  final Color? borderColor; // New property for border color
  final double? borderWidth; // New property for border width

  const CustomContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.boxDecoration,
    this.color = Colors.white,
    this.borderRadius = 4.0,
    this.boxShadow,
    this.gradient,
    this.shape = BoxShape.rectangle,
    this.alignment,
    this.child,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(10.0),
      margin: margin,
      decoration: boxDecoration ??
          BoxDecoration(
            color: color,
            borderRadius: shape == BoxShape.rectangle ? BorderRadius.all(Radius.circular(borderRadius)) : null,
            boxShadow: boxShadow != null ? [boxShadow!] : [],
            gradient: gradient,
            shape: shape,
            border: borderColor != null && borderWidth != null
                ? Border.all(color: borderColor!, width: borderWidth!)
                : null,
          ),
      alignment: alignment,
      child: child,
    );
  }
}