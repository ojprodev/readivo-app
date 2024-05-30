
import 'package:flutter/material.dart';

class Toast {
  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    double elevation = 6.0,
    double borderRadius = 0.0,
    double margin = 8.0,
    bool isFloating = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior:
        isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        elevation: isFloating ? elevation : 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: isFloating ? BorderSide.none : const BorderSide(width: 1.0),
        ),
        margin: isFloating ? EdgeInsets.all(margin) : null,
      ),
    );
  }
}