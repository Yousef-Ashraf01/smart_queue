import 'package:flutter/material.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [Icon(Icons.arrow_back, size: 30), NotificationWidget()],
    );
  }
}
