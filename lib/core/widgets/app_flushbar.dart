import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../styling/app_colors.dart';
import '../styling/app_styles.dart';

enum MessageType { success, error, warning, info }

class AppFlushbar {
  static Flushbar show(
    BuildContext context, {
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (type) {
      case MessageType.success:
        icon = Icons.check_circle;
        backgroundColor = Colors.green[100]!;
        iconColor = Colors.green;
        break;
      case MessageType.error:
        icon = Icons.error;
        backgroundColor = Colors.red[100]!;
        iconColor = Colors.red;
        break;
      case MessageType.warning:
        icon = Icons.warning_amber_outlined;
        backgroundColor = Colors.yellow[100]!;
        iconColor = Colors.orange;
        break;
      case MessageType.info:
      default:
        icon = Icons.info;
        backgroundColor = Colors.blue[100]!;
        iconColor = Colors.blue;
        break;
    }

    late final Flushbar flushbarInstance;

    flushbarInstance = Flushbar(
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: AppStyle.bold16black.copyWith(fontWeight: FontWeight.normal),
      ),
      icon: Icon(icon, color: iconColor),
      duration: duration,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.BOTTOM,
      mainButton: IconButton(
        icon: const Icon(Icons.close, color: AppColors.blackColor),
        onPressed: () => flushbarInstance.dismiss(),
      ),
    );

    flushbarInstance.show(context);
    return flushbarInstance;
  }
}
