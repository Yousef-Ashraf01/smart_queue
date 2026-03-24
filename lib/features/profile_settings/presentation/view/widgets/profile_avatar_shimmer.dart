import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatarShimmer extends StatelessWidget {
  const ProfileAvatarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 4,
                  ),
                ),
              ),
              // Container(
              //   width: 30,
              //   height: 30,
              //   decoration: const BoxDecoration(
              //     color: Colors.white,
              //     shape: BoxShape.circle,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),
          Container(width: 120, height: 20, color: Colors.white),
          const SizedBox(height: 4),
          Container(width: 150, height: 14, color: Colors.white),
        ],
      ),
    );
  }
}
