import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class ServicesItemSkeleton extends StatelessWidget {
  const ServicesItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Circle Image
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 12),

            /// Title line 1
            Container(height: 10, width: double.infinity, color: Colors.grey),

            const SizedBox(height: 8),

            /// Title line 2
            Container(height: 10, width: 80, color: Colors.grey),

            const Spacer(),

            /// Button
            Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
