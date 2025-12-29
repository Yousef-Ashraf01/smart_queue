import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    String type = "info",
    Duration duration = const Duration(seconds: 2),
  }) {
    Color backgroundColor;
    Icon icon;

    switch (type) {
      case "success":
        backgroundColor = Colors.green;
        icon = const Icon(Icons.check_circle, color: Colors.white);
        break;
      case "error":
        backgroundColor = Colors.red;
        icon = const Icon(Icons.error, color: Colors.white);
        break;
      case "warning":
        backgroundColor = Colors.orange;
        icon = const Icon(Icons.warning, color: Colors.white);
        break;
      default:
        backgroundColor = Colors.blue;
        icon = const Icon(Icons.info, color: Colors.white);
    }

    Flushbar(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12),
      icon: icon,
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }
}
