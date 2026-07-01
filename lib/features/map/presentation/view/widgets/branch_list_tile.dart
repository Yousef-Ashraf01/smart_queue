import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class BranchListTile extends StatelessWidget {
  final BranchModel branch;
  final Function(BranchModel)? onTap;

  const BranchListTile({super.key, required this.branch, this.onTap});

  String _getOperatingHoursText() {
    if (branch.operatingHours.isEmpty) return "hours_not_available".tr();

    final now = DateTime.now();
    final isoWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    final backendWeekday =
        isoWeekday - 1; // 0 = Monday, 6 = Sunday (Django backend)
    OperatingHour? todayHour;

    for (final hour in branch.operatingHours) {
      if (hour.weekday == backendWeekday) {
        todayHour = hour;
        break;
      }
    }

    if (todayHour == null) return "closed_today".tr();

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
    final ext = context.appTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: BorderDirectional(
          start: BorderSide(
            color: isActive ? AppColors.teal : ext.cardBorder,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.18 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (onTap != null) {
              onTap!(branch);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              branch.name.localizedApi,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'Inter Tight',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? Colors.green.withOpacity(0.12)
                                      : Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isActive ? "open".tr() : "closed".tr(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? (context.isDark ? Colors.green[300] : Colors.green[800])
                                    : (context.isDark ? Colors.red[300] : Colors.red[800]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ext.cardBorder.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions_walk_rounded,
                                  size: 13,
                                  color: ext.subtleText,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${branch.distanceInKm!.toStringAsFixed(1)} km',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: ext.subtleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: ext.subtleText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getOperatingHoursText(),
                              style: TextStyle(
                                fontSize: 12,
                                color: ext.subtleText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: ext.subtleText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              branch.address.localizedApiFallback(
                                "no_address_details",
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: ext.subtleText,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.green[900]!.withOpacity(0.3)
                        : AppColors.tealLight.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: context.isDark ? Colors.green[300]! : AppColors.teal,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
