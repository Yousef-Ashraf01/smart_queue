import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
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
        BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
          builder: (context, state) {
            if (state is PersonalInfoLoading) {
              return const HomeAppBarShimmer();
            }

            String? imageUrl;
            String name = '';

            if (state is PersonalInfoLoaded) {
              imageUrl = state.profile.client.imageUrl;
              name = state.profile.username;
            }

            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.personalInfo);
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.blackColor,
                    child: ClipOval(
                      child:
                          imageUrl != null && imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Image.asset(
                                      AppAssets.imageProfile,
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    ),
                              )
                              : Image.asset(
                                AppAssets.imageProfile,
                                fit: BoxFit.cover,
                                width: 48,
                                height: 48,
                              ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("hi".tr(args: [name]), style: AppStyle.bold16black),
                    Text("welcome_back".tr(), style: AppStyle.normal16black),
                  ],
                ),
              ],
            );
          },
        ),
        const NotificationWidget(),
      ],
    );
  }
}
