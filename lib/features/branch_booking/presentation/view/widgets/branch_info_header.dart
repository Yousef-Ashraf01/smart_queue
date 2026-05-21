import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchInfoHeader extends StatelessWidget {
  final BranchModel branch;

  const BranchInfoHeader({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(branch.name, style: AppStyle.bold24black),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(branch.address ?? "No address"),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap:
              () => launchUrl(
                Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=${branch.lat},${branch.lng}",
                ),
              ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, size: 18, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "View on Map",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(branch.phone ?? "", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
