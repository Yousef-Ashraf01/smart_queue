import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPress;
  final VoidCallback? onNotificationPress;
  final bool showNotificationDot;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPress,
    this.onNotificationPress,
    this.showNotificationDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 30),
                onPressed: () {
                  if (onBackPress != null) {
                    onBackPress!();
                  } else if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    debugPrint("لا يوجد صفحة سابقة للرجوع إليها");
                  }
                },
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    onTap: onNotificationPress,
                    borderRadius: BorderRadius.circular(20),
                    child: SvgPicture.asset(AppAssets.iconBell, width: 45),
                  ),
                  if (showNotificationDot)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyle.appBarTitle,
          ),
        ],
      ),
    );
  }
}