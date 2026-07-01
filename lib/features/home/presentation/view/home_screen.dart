import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/home/presentation/cubit/organization_cubit.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/active_booking_summary.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/home_app_bar.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/live_branches_map_carousel.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/services_list_view.dart';

import '../../../../core/di/service_locator.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToQueue;
  final VoidCallback? onNavigateToAppointments;

  const HomeScreen({
    super.key,
    this.onNavigateToQueue,
    this.onNavigateToAppointments,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;

    return BlocProvider(
      create: (_) => sl<OrganizationsCubit>()..fetchOrganizations(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ext.bgGradientTop, ext.bgGradientBottom],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeAppBar(),
                const SizedBox(height: 23),
                ActiveBookingSummary(onTap: () => onNavigateToQueue?.call()),
                const SizedBox(height: 23),
                Text(
                  "gov_agencies".tr(),
                  style: AppStyle.bold16black.adaptive(context),
                ),
                const SizedBox(height: 16),
                const ServicesListView(),
                const SizedBox(height: 28),
                const LiveBranchesMapCarousel(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

