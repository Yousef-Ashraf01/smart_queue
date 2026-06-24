import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.tealLight.withOpacity(0.5),
          width: 1.2,
        ),
        boxShadow: [
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
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.person_outline_rounded, 'full_name_label'.tr(), name),
                const _InfoDivider(),
                _buildInfoRow(Icons.badge_outlined, 'national_id_label'.tr(), nationalId),
                const _InfoDivider(),
                _buildInfoRow(Icons.location_on_outlined, 'address_label'.tr(), address),
                const _InfoDivider(),
                _buildInfoRow(Icons.cake_outlined, 'birth_date_label'.tr(), birthDate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tealLight.withOpacity(0.3),
            AppColors.tealLight.withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.teal,
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
            style: const TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.teal,
            ),
          ),
          const Spacer(),
          const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.greyText),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.teal.withOpacity(0.6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 11, 
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
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
      color: Colors.grey.withOpacity(0.15),
    );
  }
}
