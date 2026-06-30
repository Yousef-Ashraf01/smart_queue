import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/services/bookmark_service.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_history_item.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_skeleton_item.dart';

import '../../../../core/di/service_locator.dart';

class OperationsHistoryScreen extends StatefulWidget {
  const OperationsHistoryScreen({super.key});

  @override
  State<OperationsHistoryScreen> createState() =>
      _OperationsHistoryScreenState();
}

class _OperationsHistoryScreenState extends State<OperationsHistoryScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final BookmarkService _bookmarkService = sl<BookmarkService>();
  Set<int> _bookmarkedIds = {};
  int _selectedFilter = 0;

  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnim;
  late Animation<Offset> _headerSlideAnim;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFadeAnim = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerSlideAnim = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimController,
        curve: Curves.easeOutCubic,
      ),
    );
    _headerAnimController.forward();

    context.read<OperationsCubit>().fetchOperations();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        context.read<OperationsCubit>().loadMore();
      }
    });
  }

  Future<void> _loadBookmarks() async {
    final ids = await _bookmarkService.getBookmarked();
    setState(() => _bookmarkedIds = ids);
  }

  Future<void> _toggleBookmark(int id) async {
    await _bookmarkService.toggleBookmark(id);
    final isNowBookmarked = !_bookmarkedIds.contains(id);
    setState(() {
      if (_bookmarkedIds.contains(id)) {
        _bookmarkedIds.remove(id);
      } else {
        _bookmarkedIds.add(id);
      }
    });

    AppFlushbar.show(
      context,
      message:
          isNowBookmarked
              ? "appointment_saved".tr()
              : "appointment_removed".tr(),
      type: isNowBookmarked ? MessageType.success : MessageType.warning,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SlideTransition(
              position: _headerSlideAnim,
              child: FadeTransition(
                opacity: _headerFadeAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "my_appointments_title".tr(),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF1A1D4E),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                BlocBuilder<OperationsCubit, OperationsState>(
                                  builder: (context, state) {
                                    final count =
                                        state is OperationsLoaded
                                            ? state.operations.length
                                            : 0;
                                    return Text(
                                      state is OperationsLoaded
                                          ? "appointments_found".tr(
                                            args: [count.toString()],
                                          )
                                          : "loading".tr(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const NotificationWidget(),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _FilterChip(
                              label: "all".tr(),
                              icon: Icons.grid_view_rounded,
                              isSelected: _selectedFilter == 0,
                              onTap: () => setState(() => _selectedFilter = 0),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: "upcoming".tr(),
                              icon: Icons.event_available_rounded,
                              isSelected: _selectedFilter == 1,
                              onTap: () => setState(() => _selectedFilter = 1),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: "completed".tr(),
                              icon: Icons.check_circle_outline_rounded,
                              isSelected: _selectedFilter == 2,
                              onTap: () => setState(() => _selectedFilter = 2),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: "saved".tr(),
                              icon: Icons.bookmark_outline_rounded,
                              isSelected: _selectedFilter == 3,
                              onTap: () => setState(() => _selectedFilter = 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<OperationsCubit, OperationsState>(
                builder: (context, state) {
                  if (state is OperationsLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (_, __) => const OperationSkeletonItem(),
                      ),
                    );
                  }

                  if (state is OperationsError) {
                    return _ErrorState(
                      message: state.message.localizedApi,
                      onRetry:
                          () =>
                              context.read<OperationsCubit>().fetchOperations(),
                    );
                  }

                  if (state is OperationsLoaded) {
                    final filtered = _applyFilter(state.operations);

                    if (filtered.isEmpty) {
                      return _EmptyState(filter: _selectedFilter);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<OperationsCubit>().fetchOperations();
                      },
                      color: const Color(0xFF10B981),
                      backgroundColor: Colors.white,
                      displacement: 20,
                      child: AnimationLimiter(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount:
                              filtered.length + (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filtered.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final item = filtered[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 450),
                              child: SlideAnimation(
                                verticalOffset: 40,
                                child: FadeInAnimation(
                                  child: OperationHistoryItem(
                                    item: item,
                                    isBookmarked: _bookmarkedIds.contains(
                                      item.id,
                                    ),
                                    onBookmarkTap:
                                        () => _toggleBookmark(item.id!),
                                    onTap: () async {
                                      final result = await context.push(
                                        AppRoutes.appointmentDetails,
                                        extra: item.id,
                                      );

                                      if (result == true) {
                                        context
                                            .read<OperationsCubit>()
                                            .removeAppointment(item.id!);
                                      }

                                      final isStillBookmarked =
                                          await _bookmarkService.isBookmarked(
                                            item.id!,
                                          );
                                      if (!isStillBookmarked &&
                                          _bookmarkedIds.contains(item.id)) {
                                        setState(
                                          () => _bookmarkedIds.remove(item.id),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List _applyFilter(List operations) {
    switch (_selectedFilter) {
      case 1:
        return operations.where((op) {
          if (op.canceled || op.missed) return false;
          try {
            final d = DateTime.parse(op.date);
            return !d.isBefore(
              DateTime.now().subtract(const Duration(days: 1)),
            );
          } catch (_) {
            return true;
          }
        }).toList();
      case 2:
        return operations.where((op) {
          if (op.canceled || op.missed) return false;
          try {
            final d = DateTime.parse(op.date);
            return d.isBefore(DateTime.now().subtract(const Duration(days: 1)));
          } catch (_) {
            return false;
          }
        }).toList();
      case 3:
        return operations
            .where((op) => _bookmarkedIds.contains(op.id))
            .toList();
      default:
        return operations;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  )
                  : null,
          color: isSelected ? null : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.grey.withOpacity(0.15),
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final data = _emptyData;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.08),
                    const Color(0xFF3B82F6).withOpacity(0.06),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 44, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D4E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _EmptyData get _emptyData {
    switch (filter) {
      case 1:
        return _EmptyData(
          icon: Icons.event_busy_rounded,
          title: "no_upcoming_appointments".tr(),
          subtitle: "no_upcoming_appointments_desc".tr(),
        );
      case 2:
        return _EmptyData(
          icon: Icons.history_rounded,
          title: "no_history_yet".tr(),
          subtitle: "completed_appointments_appear".tr(),
        );
      case 3:
        return _EmptyData(
          icon: Icons.bookmark_outline_rounded,
          title: "no_saved_appointments".tr(),
          subtitle: "bookmark_appointments_quickly".tr(),
        );
      default:
        return _EmptyData(
          icon: Icons.calendar_today_rounded,
          title: "no_appointments_yet".tr(),
          subtitle: "book_first_appointment".tr(),
        );
    }
  }
}

class _EmptyData {
  final IconData icon;
  final String title;
  final String subtitle;

  _EmptyData({required this.icon, required this.title, required this.subtitle});
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 36,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "something_went_wrong".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D4E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "try_again".tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
