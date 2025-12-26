import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 44,
      width: 44,
      child: SvgPicture.asset(
        AppAssets.iconNotifications,
        color: Color(0xff667791),
        fit: BoxFit.cover,
        width: 20,
        height: 20,
      ),
    );
  }
}
