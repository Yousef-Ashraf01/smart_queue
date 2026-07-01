import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/branch_list_tile.dart';

class BranchesBottomSheet extends StatelessWidget {
  final List<BranchModel> branches;
  final BranchModel? selectedBranch;
  final Function(BranchModel)? onBranchTap;
  final VoidCallback? onCloseDetails;

  const BranchesBottomSheet({
    super.key,
    required this.branches,
    this.selectedBranch,
    this.onBranchTap,
    this.onCloseDetails,
  });

  String _getOperatingHoursText(BranchModel branch) {
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
    final bool isBranchSelected = selectedBranch != null;
    final double height = isBranchSelected ? 260 : 320;
    final ext = context.appTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: height,
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: ext.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.24 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child:
                isBranchSelected
                    ? _buildSelectedBranchView(context, selectedBranch!)
                    : _buildBranchListView(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedBranchView(BuildContext context, BranchModel branch) {
    final isActive = branch.isCurrentlyOpen;
    final ext = context.appTheme;
    return Padding(
      key: const ValueKey('SelectedBranchView'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: ext.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  branch.name.localizedApi,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Inter Tight',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: ext.cardBorder.withOpacity(0.35),
                  padding: const EdgeInsets.all(8),
                ),
                icon: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: ext.subtleText,
                ),
                onPressed: onCloseDetails,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ext.cardBorder.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      size: 13,
                      color: ext.subtleText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${branch.distanceInKm?.toStringAsFixed(1) ?? "0.0"} km',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              const SizedBox(width: 12),
              Icon(Icons.access_time_rounded, size: 13, color: ext.subtleText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _getOperatingHoursText(branch),
                  style: TextStyle(fontSize: 12, color: ext.subtleText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: ext.subtleText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  branch.address.localizedApiFallback("no_address_details"),
                  style: TextStyle(
                    fontSize: 12,
                    color: ext.subtleText,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: context.isDark
                      ? [Colors.green[400]!, Colors.green[700]!]
                      : [AppColors.tealLight, AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (context.isDark ? Colors.green[300]! : AppColors.teal)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.push(AppRoutes.branchBooking, extra: branch);
                },
                child: Text(
                  "book_appointment".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchListView(BuildContext context) {
    final ext = context.appTheme;
    return Padding(
      key: const ValueKey('BranchListView'),
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4.5,
              decoration: BoxDecoration(
                color: ext.cardBorder,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'nearby_branches'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Inter Tight',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: context.isDark
                        ? Colors.green[900]!.withOpacity(0.3)
                        : AppColors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${branches.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.isDark ? Colors.green[300]! : AppColors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (branches.isEmpty)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ext.cardBorder.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: ext.subtleText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "no_branches_found".tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "no_branches_search_desc".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: ext.subtleText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                itemCount: branches.length,
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
    );
  }
}
