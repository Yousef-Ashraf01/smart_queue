import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppBarShimmer extends StatelessWidget {
  const HomeAppBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Shimmer.fromColors(
        //   baseColor: Colors.grey.shade300,
        //   highlightColor: Colors.grey.shade100,
        //   child: const CircleAvatar(radius: 20, backgroundColor: Colors.white),
        // ),
        // const SizedBox(width: 20),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _ShimmerBox(width: 120, height: 16),
              SizedBox(height: 8),
              _ShimmerBox(width: 90, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: height, color: Colors.white);
  }
}
