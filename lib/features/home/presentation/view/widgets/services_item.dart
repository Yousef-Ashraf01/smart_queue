import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/home/data/models/organization_model.dart';

class ServicesItem extends StatelessWidget {
  final OrganizationModel organization;

  const ServicesItem({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.9, end: 1),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: ClipOval(
                child:
                    organization.image != null
                        ? Image.network(
                          organization.image!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.account_balance),
                        )
                        : const Icon(Icons.account_balance),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              organization.name.localizedApi,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bold16black.copyWith(fontSize: 14),
            ),

            Text(
              organization.code.localizedApi,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 32,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff3CC572)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  context.push(AppRoutes.map, extra: organization.id);
                },
                child: Text("book_btn".tr(), style: AppStyle.regular14black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
