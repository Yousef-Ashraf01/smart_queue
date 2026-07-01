import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class IdInfoCard extends StatelessWidget {
  final String name;
  final String nationalId;
  final String address;
  final String birthDate;

  const IdInfoCard({
    super.key,
    required this.name,
    required this.nationalId,
    required this.address,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;
    final borderGreen = isDark
        ? Colors.green[800]!.withOpacity(0.4)
        : AppColors.tealLight.withOpacity(0.5);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderGreen,
          width: 1.2,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(context, Icons.person_outline_rounded, 'full_name_label'.tr(), name),
                const _InfoDivider(),
                _buildInfoRow(context, Icons.badge_outlined, 'national_id_label'.tr(), nationalId),
                const _InfoDivider(),
                _buildInfoRow(context, Icons.location_on_outlined, 'address_label'.tr(), address),
                const _InfoDivider(),
                _buildInfoRow(context, Icons.cake_outlined, 'birth_date_label'.tr(), birthDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;
    final headerGradientColors = isDark
        ? [
            Colors.green[900]!.withOpacity(0.4),
            Colors.green[900]!.withOpacity(0.1),
          ]
        : [
            AppColors.tealLight.withOpacity(0.3),
            AppColors.tealLight.withOpacity(0.1),
          ];
    final badgeColor = isDark ? Colors.green[800]! : AppColors.teal;
    final textColor = isDark ? Colors.green[300]! : AppColors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: headerGradientColors,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.badge_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'verified_from_id'.tr(),
            style: TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const Spacer(),
          Icon(Icons.lock_outline_rounded, size: 14, color: ext.subtleText),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final isDark = context.isDark;
    final ext = context.appTheme;
    final iconColor = isDark ? Colors.green[300]!.withOpacity(0.7) : AppColors.teal.withOpacity(0.6);
    final valueColor = isDark ? Colors.green[300]! : AppColors.teal;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 11,
                    color: ext.subtleText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 16,
      thickness: 0.8,
      color: context.appTheme.cardBorder.withOpacity(0.15),
    );
  }
}
