import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/services/bookmark_service.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_history_item.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_skeleton_item.dart';

import '../../../../core/di/service_locator.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final BookmarkService _bookmarkService = sl<BookmarkService>();
  final BookingRepository _repository = sl<BookingRepository>();
  List<AppointmentResponseModel> _bookmarkedAppointments = [];
  Set<int> _bookmarkedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedAppointments();
  }

  Future<void> _loadBookmarkedAppointments() async {
    setState(() => _isLoading = true);

    final ids = await _bookmarkService.getBookmarked();
    setState(() => _bookmarkedIds = ids);

    if (ids.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final result = await _repository.getOperations(null);

    result.fold((failure) => setState(() => _isLoading = false), (data) {
      final bookmarked = data.items.where((op) => ids.contains(op.id)).toList();

      setState(() {
        _bookmarkedAppointments = bookmarked;
        _isLoading = false;
      });
    });

    final state = context.read<OperationsCubit>().state;
    if (state is OperationsLoaded) {
      final bookmarked =
          state.operations.where((op) => ids.contains(op.id)).toList();

      setState(() {
        _bookmarkedAppointments = bookmarked;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleBookmark(int id) async {
    await _bookmarkService.toggleBookmark(id);

    setState(() {
      _bookmarkedIds.remove(id);
      _bookmarkedAppointments.removeWhere((op) => op.id == id);
    });

    AppFlushbar.show(
      context,
      message: "appointment_removed_saved".tr(),
      type: MessageType.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ext.bgGradientTop, ext.bgGradientBottom],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
          child: Column(
            children: [
              AppTopBar(),
              Text(
                "my_appointments_title".tr(),
                style: AppStyle.bold24black.adaptive(context),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const OperationSkeletonItem(),
      );
    }

    if (_bookmarkedAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.appTheme.cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: context.appTheme.cardBorder),
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 52,
                color: context.appTheme.subtleText,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "no_saved_appointments".tr(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "bookmark_to_find_easily".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: context.appTheme.subtleText,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return AnimationLimiter(
      child: ListView.builder(
        itemCount: _bookmarkedAppointments.length,
        itemBuilder: (context, index) {
          final item = _bookmarkedAppointments[index];

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 30,
              child: FadeInAnimation(
                child: OperationHistoryItem(
                  item: item,
                  isBookmarked: _bookmarkedIds.contains(item.id),
                  onBookmarkTap: () => _toggleBookmark(item.id!),
                  onTap: () async {
                    final result = await context.push(
                      AppRoutes.appointmentDetails,
                      extra: item.id,
                    );

                    if (result == true) {
                      _loadBookmarkedAppointments();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
