import 'package:flutter/material.dart';

class SnackbarHelper {
  /// Shows a floating SnackBar with your own message.
  static void showMessage(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 2),
        Color backgroundColor = const Color(0xFF2B5C74),
      }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}