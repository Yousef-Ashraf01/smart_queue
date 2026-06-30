import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyServices extends StatelessWidget {
  const EmptyServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "no_services_yet".tr(),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
