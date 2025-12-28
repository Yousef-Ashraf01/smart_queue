import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/branch_list_tile.dart';

import '../../../../../core/styling/app_colors.dart';

class BranchesBottomSheet extends StatelessWidget {
  final List<GovernmentBranch> branches;

  const BranchesBottomSheet({super.key, required this.branches});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 260,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Center(
              child: Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nearby Branches', style: AppStyle.bold18black),
            const Text(
              'Choose the nearest branch',
              style: TextStyle(color: AppColors.greyColor),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  branches.isEmpty
                      ? const Center(
                        child: Text(
                          'No nearby branches found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.separated(
                        itemCount: branches.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final branch = branches[index];
                          return BranchListTile(branch: branch);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
