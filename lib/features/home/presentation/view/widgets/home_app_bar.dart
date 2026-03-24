import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/home_app_bar_shimmer.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push(AppRoutes.personalInfo);
              },
              child: CircleAvatar(
                backgroundColor: AppColors.blackColor,
                child: Image.asset(AppAssets.imageProfile, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20),

            BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
              builder: (context, state) {
                if (state is PersonalInfoLoading) {
                  return const HomeAppBarShimmer();
                }

                if (state is PersonalInfoLoaded) {
                  final name = state.profile.username ?? '';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, $name", style: AppStyle.bold16black),
                      Text("Welcome back!", style: AppStyle.normal16black),
                    ],
                  );
                }

                if (state is PersonalInfoError) {
                  return const Text("Hi");
                }

                return const SizedBox();
              },
            ),
          ],
        ),
        const NotificationWidget(),
      ],
    );
  }
}
