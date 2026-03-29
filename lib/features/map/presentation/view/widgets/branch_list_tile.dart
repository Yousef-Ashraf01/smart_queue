import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';

class BranchListTile extends StatelessWidget {
  final GovernmentBranch branch;

  const BranchListTile({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        branch.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${branch.distanceInKm!.toStringAsFixed(1)} km away',
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.calendar_month, color: Colors.grey[600]),
      ),
      onTap: () {
        context.push(AppRoutes.branchBooking, extra: branch);
      },
    );
  }
}
