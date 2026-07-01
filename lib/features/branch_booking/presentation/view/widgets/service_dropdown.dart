import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';

class ServiceDropdown extends StatelessWidget {
  final ServiceCounterModel? selectedService;

  const ServiceDropdown({super.key, this.selectedService});

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedService != null;
    final ext = context.appTheme;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.teal.withOpacity(0.03) : ext.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              isSelected
                  ? AppColors.teal.withOpacity(0.3)
                  : ext.cardBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.12 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.teal.withOpacity(0.1)
                        : AppColors.tealLight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.design_services_rounded,
                color: AppColors.teal,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedService?.serviceName.localizedApi ??
                        "select_service".tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.teal : ext.subtleText,
                      fontFamily: 'Inter Tight',
                    ),
                  ),
                  if (isSelected &&
                      selectedService?.serviceDescription != null &&
                      selectedService!.serviceDescription.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      selectedService!.serviceDescription.localizedApi,
                      style: TextStyle(
                        fontSize: 11,
                        color: ext.subtleText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Trailing Price badge
            if (isSelected && selectedService?.servicePrice != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${selectedService!.servicePrice} EGP",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ext.subtleText,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
