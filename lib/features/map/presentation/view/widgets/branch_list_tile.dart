import 'package:flutter/material.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class BranchListTile extends StatelessWidget {
  final BranchModel branch;
  final Function(BranchModel)? onTap;

  const BranchListTile({super.key, required this.branch, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = branch.isActive ?? false;

    return ListTile(
      title: Text(
        branch.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${branch.distanceInKm!.toStringAsFixed(1)} km away',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            branch.address ?? "No address",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
      leading: Icon(
        Icons.circle,
        size: 10,
        color: isActive ? Colors.green : Colors.red,
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
        if (onTap != null) {
          onTap!(branch);
        }
      },
    );
  }
}
