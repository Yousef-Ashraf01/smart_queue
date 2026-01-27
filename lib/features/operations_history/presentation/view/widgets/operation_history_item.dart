import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

import '../../../../../core/styling/app_colors.dart';

class OperationHistoryItem extends StatelessWidget {
  const OperationHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(27, 4, 27, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.bookmark_border),
              ),
              const Spacer(),
              const Text(
                'National Postal Authority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.whiteColor,
                child: Image.asset(
                  AppAssets.imagePostal,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(color: Colors.grey.shade300, thickness: 1),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              const Text(
                'Zagazig, Sharqia, Egypt',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              const Text(
                '27/1/2025',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
