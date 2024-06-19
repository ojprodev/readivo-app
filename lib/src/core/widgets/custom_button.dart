import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

/// An enum representing different styles for the CustomButton.
enum ButtonStyleType {
  /// A filled style button with a solid background color.
  filled,

  /// An outline style button with a border and transparent background.
  outline,

  /// A ghost style button with transparent background and colored text only.
  ghost,
}

/// A customizable button widget with support for different styles and colors.
class CustomButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;

  /// Button child item
  final Widget? child;

  /// The callback function invoked when the button is pressed.
  final VoidCallback? onPressed;

  /// The style type of the button (filled, outline, or ghost).
  final ButtonStyleType styleType;

  /// The background color of the button (used for filled and ghost styles).
  final Color? color;

  /// The text color of the button.
  final Color? textColor;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The border radius
  final double borderRadius;

  /// The border color
  final Color? borderColor;

  /// The border width
  final double borderWidth;

  /// Enabled
  final bool enabled;

  /// Creates a customizable button widget.
  ///
  /// The [text] parameter is required and specifies the text displayed on the button.
  ///
  /// The [onPressed] parameter is required and specifies the callback function invoked when the button is pressed.
  ///
  /// The [styleType] parameter specifies the style type of the button (filled, outline, or ghost). Default is [ButtonStyleType.filled].
  ///
  /// The [color] parameter specifies the background color of the button (used for filled and ghost styles). Default is null, which uses the primary theme color.
  ///
  /// The [textColor] parameter specifies the text color of the button. Default is null, which uses the default text color based on the button style.
  ///
  /// The [width] parameter specifies the width of the button. Default is 120.
  ///
  /// The [height] parameter specifies the height of the button. Default is 40.
  ///
  /// The [borderRadius] parameter specifies the button's border radius value, Default is 8.0
  ///
  /// The [borderColor] parameter specifies the button's border Color, Default is transparent
  ///
  /// The [borderWidth] parameter specifies the button's border width, Default is 2.0
  ///
  /// The [enabled] parameter set the enabled state of the button, default is true

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.styleType = ButtonStyleType.filled,
    this.color,
    this.textColor,
    this.width = 100,
    this.height = 40,
    this.borderRadius = 4.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.transparent,
    this.enabled = true,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          enableFeedback: enabled,
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          backgroundColor:
              WidgetStateProperty.all<Color>(_getButtonColor(theme)),
          foregroundColor: WidgetStateProperty.all<Color>(_getTextColor(theme)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: styleType == ButtonStyleType.outline
                  ? BorderSide(
                      color: _getBorderColor(theme), width: borderWidth)
                  : BorderSide(color: _getBorderColor(theme), width: borderWidth),
            ),
          ),
        ),
        child: ConditionalBuilder(
          condition: child != null,
          builder: (context) => child!,
          fallback: (context) => Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(ThemeData theme) {
    switch (styleType) {
      case ButtonStyleType.filled:
        return color ?? theme.primaryColor;
      case ButtonStyleType.outline:
        return Colors.transparent;
      case ButtonStyleType.ghost:
        return Colors.transparent;
    }
  }

  Color _getBorderColor(ThemeData theme) {
    return borderColor ?? theme.primaryColor;
  }

  Color _getTextColor(ThemeData theme) {
    switch (styleType) {
      case ButtonStyleType.filled:
        return textColor ?? Colors.white;
      case ButtonStyleType.outline:
        return textColor ?? (color ?? theme.primaryColor);
      case ButtonStyleType.ghost:
        return textColor ?? (color ?? theme.primaryColor);
    }
  }
}
