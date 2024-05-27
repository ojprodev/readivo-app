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
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            boxShadow: boxShadow != null ? [boxShadow!] : [],
            gradient: gradient,
            shape: shape,
          ),
      alignment: alignment,
      child: child,
    );
  }
}
