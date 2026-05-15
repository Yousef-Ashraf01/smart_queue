import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/services/bookmark_service.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
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

class _OperationsHistoryScreenState extends State<OperationsHistoryScreen> {
  final ScrollController scrollController = ScrollController();
  final BookmarkService _bookmarkService = sl<BookmarkService>();
  Set<int> _bookmarkedIds = {};

  @override
  void initState() {
    super.initState();
    _loadBookmarks();

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
      message: isNowBookmarked ? "Appointment saved!" : "Appointment removed!",
      type: isNowBookmarked ? MessageType.success : MessageType.warning,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 52, 30, 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: NotificationWidget(),
            ),
            const SizedBox(height: 20),
            Text("Appointments History", style: AppStyle.bold24black),
            Expanded(
              child: BlocBuilder<OperationsCubit, OperationsState>(
                builder: (context, state) {
                  if (state is OperationsLoading) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (_, __) => const OperationSkeletonItem(),
                    );
                  }

                  if (state is OperationsError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is OperationsLoaded) {
                    if (state.operations.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.history, size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No operations yet"),
                        ],
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<OperationsCubit>().fetchOperations();
                      },
                      color: Colors.green[200],
                      child: AnimationLimiter(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.operations.length,
                          itemBuilder: (context, index) {
                            final item = state.operations[index];

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 30,
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
                          // itemBuilder: (context, index) {
                          //   final item = state.operations[index];
                          //
                          //   // return AnimationConfiguration.staggeredList(
                          //   //   position: index,
                          //   //   duration: const Duration(milliseconds: 400),
                          //   //   child: SlideAnimation(
                          //   //     verticalOffset: 30,
                          //   //     child: FadeInAnimation(
                          //   //       child: OperationHistoryItem(
                          //   //         title: "Appointment #${item.id}",
                          //   //         location: item.address,
                          //   //         date: item.id.toString(),
                          //   //         imageAsset: AppAssets.imagePostal,
                          //   //         isBookmarked: _bookmarkedIds.contains(
                          //   //           item.id,
                          //   //         ),
                          //   //         onBookmarkTap:
                          //   //             () => _toggleBookmark(item.id!),
                          //   //         onTap: () async {
                          //   //           final result = await context.push(
                          //   //             AppRoutes.appointmentDetails,
                          //   //             extra: item.id,
                          //   //           );
                          //   //
                          //   //           if (result == true) {
                          //   //             context
                          //   //                 .read<OperationsCubit>()
                          //   //                 .removeAppointment(item.id!);
                          //   //           }
                          //   //
                          //   //           final isStillBookmarked =
                          //   //               await _bookmarkService.isBookmarked(
                          //   //                 item.id!,
                          //   //               );
                          //   //           if (!isStillBookmarked &&
                          //   //               _bookmarkedIds.contains(item.id)) {
                          //   //             setState(
                          //   //               () => _bookmarkedIds.remove(item.id),
                          //   //             );
                          //   //           }
                          //   //         },
                          //   //       ),
                          //   //     ),
                          //   //   ),
                          //   // );
                          // },
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
}
