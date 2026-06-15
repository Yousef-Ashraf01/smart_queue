import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/widgets/notification_inbox_sheet.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
      builder: (context, state) {
        final count = state is ActiveBookingLoaded ? state.bookings.length : 0;
        final showBadge = count > 0;

        return GestureDetector(
          onTap: () async {
            if (showBadge) {
              await BookingStatusSheet.show(context);
            } else {
              context.push(AppRoutes.timer);
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 44,
                width: 44,
                child: SvgPicture.asset(
                  AppAssets.iconNotifications,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff667791),
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
              ),
              if (showBadge)
                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE24B4A),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
