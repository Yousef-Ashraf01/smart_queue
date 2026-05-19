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
            clipBehavior: Clip.none,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
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
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: 120,
            height: 20,
            decoration: BorderRadius.circular(
              6,
            ).toBoxDecoration(color: Colors.white),
          ),

          const SizedBox(height: 4),

          Container(width: 150, height: 14, color: Colors.white),
        ],
      ),
    );
  }
}

extension on BorderRadius {
  BoxDecoration toBoxDecoration({required Color color}) {
    return BoxDecoration(color: color, borderRadius: this);
  }
}
