import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.blackColor,
              child: Image.asset(AppAssets.imageProfile, fit: BoxFit.cover),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hi, Yousef Ashraf", style: AppStyle.bold16black),
                Text(" Welcome back!", style: AppStyle.normal16black),
              ],
            ),
          ],
        ),
        NotificationWidget(),
      ],
    );
  }
}
