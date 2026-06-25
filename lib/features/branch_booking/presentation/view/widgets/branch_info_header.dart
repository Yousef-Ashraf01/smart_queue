import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchInfoHeader extends StatelessWidget {
  final BranchModel branch;

  const BranchInfoHeader({super.key, required this.branch});

  void _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String _getOperatingHoursText() {
    if (branch.operatingHours.isEmpty) return "Not available";

    final now = DateTime.now();
    final isoWeekday = now.weekday;
    final backendWeekday = isoWeekday - 1; // 0 = Monday, 6 = Sunday (Django backend)
    OperatingHour? todayHour;

    for (final hour in branch.operatingHours) {
      if (hour.weekday == backendWeekday) {
        todayHour = hour;
        break;
      }
    }

    if (todayHour == null) return "Closed Today";

    final fromStr = _formatTime(todayHour.fromHour);
    final toStr = _formatTime(todayHour.toHour);
    return "$fromStr - $toStr";
  }

  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
        final displayMinute = minute.toString().padLeft(2, '0');
        return '$displayHour:$displayMinute $period';
      }
    } catch (_) {}
    return timeStr;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = branch.isCurrentlyOpen;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top accent gradient bar
          Container(
            height: 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.tealLight, AppColors.teal],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Status Badge Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        branch.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.teal,
                          fontFamily: 'Inter Tight',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isActive ? "Open" : "Closed",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Address Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        branch.address ?? "No address details available",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Operating Hours Row
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      "Today's Hours: ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      _getOperatingHoursText(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1),
                ),

                // Contact and Actions Row
                Row(
                  children: [
                    // Phone Button
                    if (branch.phone != null && branch.phone!.isNotEmpty)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _makePhoneCall(branch.phone!),
                          icon: const Icon(Icons.phone_rounded, size: 16),
                          label: Text(
                            branch.phone!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.teal,
                            side: BorderSide(color: AppColors.teal.withOpacity(0.2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          ),
                        ),
                      ),
                    if (branch.phone != null && branch.phone!.isNotEmpty)
                      const SizedBox(width: 8),

                    // Map View Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => launchUrl(
                          Uri.parse(
                            "https://www.google.com/maps/search/?api=1&query=${branch.lat},${branch.lng}",
                          ),
                        ),
                        icon: const Icon(Icons.map_rounded, size: 16),
                        label: const Text("View on Map", style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealLight.withOpacity(0.15),
                          foregroundColor: AppColors.teal,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),

                // Email button if available
                if (branch.email != null && branch.email!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _sendEmail(branch.email!),
                      icon: const Icon(Icons.email_rounded, size: 16),
                      label: Text(
                        branch.email!,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.tealMuted,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

