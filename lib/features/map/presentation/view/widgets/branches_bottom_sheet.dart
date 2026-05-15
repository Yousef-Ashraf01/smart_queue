import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/branch_list_tile.dart';

class BranchesBottomSheet extends StatelessWidget {
  final List<BranchModel> branches;
  final Function(BranchModel)? onBranchTap;

  const BranchesBottomSheet({
    super.key,
    required this.branches,
    this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 16),

            Text('Nearby Branches', style: AppStyle.bold16black),

            const SizedBox(height: 12),

            Expanded(
              child:
                  branches.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No branches found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: branches.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              color: Colors.grey.shade300,
                              thickness: 0.8,
                            ),
                        itemBuilder: (context, index) {
                          return BranchListTile(
                            branch: branches[index],
                            onTap: onBranchTap,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
