import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/routing/app_router.dart';

enum MessageType { success, error, warning, info }

class AppFlushbar {
  static Flushbar show(
    BuildContext context, {
    required String message,
    String? title,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final showContext = AppRouter.navigatorKey.currentContext ?? context;
    final _FlushbarStyle style = _FlushbarStyle.of(type);

    late final Flushbar flushbarInstance;

    flushbarInstance = Flushbar(
      titleText:
          title != null
              ? Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: style.titleColor,
                ),
              )
              : null,
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, color: style.textColor, height: 1.4),
      ),
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: style.iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(style.icon, color: style.iconColor, size: 20),
      ),
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: BorderRadius.circular(18),
      backgroundColor: style.backgroundColor,
      flushbarPosition: FlushbarPosition.BOTTOM,
      boxShadows: [
        BoxShadow(
          color: style.iconColor.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
      mainButton: GestureDetector(
        onTap: () => flushbarInstance.dismiss(),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: style.iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.close_rounded, color: style.iconColor, size: 14),
        ),
      ),
    );

    flushbarInstance.show(showContext);
    return flushbarInstance;
  }
}

class _FlushbarStyle {
  final Color backgroundColor;
  final Color iconBg;
  final Color iconColor;
  final Color titleColor;
  final Color textColor;
  final IconData icon;

  const _FlushbarStyle({
    required this.backgroundColor,
    required this.iconBg,
    required this.iconColor,
    required this.titleColor,
    required this.textColor,
    required this.icon,
  });

  static _FlushbarStyle of(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const _FlushbarStyle(
          backgroundColor: Color(0xFFF0FBF7),
          iconBg: Color(0xFFE1F5EE),
          iconColor: Color(0xFF1A9E7A),
          titleColor: Color(0xFF085041),
          textColor: Color(0xFF1A9E7A),
          icon: Icons.check_circle_outline_rounded,
        );
      case MessageType.error:
        return _FlushbarStyle(
          backgroundColor: const Color(0xFFFFF5F5),
          iconBg: const Color(0xFFFFE5E5),
          iconColor: Colors.red.shade600,
          titleColor: Colors.red.shade900,
          textColor: Colors.red.shade600,
          icon: Icons.error_outline_rounded,
        );
      case MessageType.warning:
        return const _FlushbarStyle(
          backgroundColor: Color(0xFFFFFBF0),
          iconBg: Color(0xFFFFF3CD),
          iconColor: Color(0xFFFB8C00),
          titleColor: Color(0xFF7B4F00),
          textColor: Color(0xFFFB8C00),
          icon: Icons.warning_amber_rounded,
        );
      case MessageType.info:
        return const _FlushbarStyle(
          backgroundColor: Color(0xFFF0F4FF),
          iconBg: Color(0xFFE0E8FF),
          iconColor: Color(0xFF3B5BDB),
          titleColor: Color(0xFF1E3A8A),
          textColor: Color(0xFF3B5BDB),
          icon: Icons.info_outline_rounded,
        );
    }
  }
}
