import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/operations_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_history_item.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_skeleton_item.dart';

class OperationsHistoryScreen extends StatefulWidget {
  const OperationsHistoryScreen({super.key});

  @override
  State<OperationsHistoryScreen> createState() =>
      _OperationsHistoryScreenState();
}

class _OperationsHistoryScreenState extends State<OperationsHistoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        context.read<OperationsCubit>().loadMore();
      }
    });
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: NotificationWidget(),
              ),
              const SizedBox(height: 10),
              Text("Operations History", style: AppStyle.bold24black),
              const SizedBox(height: 5),
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
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: state.operations.length,
                          itemBuilder: (context, index) {
                            final item = state.operations[index];

                            return OperationHistoryItem(
                              title: "Appointment #${item.id}",
                              location: item.address,
                              date: item.id.toString(),
                              imageAsset: AppAssets.imagePostal,
                            );
                          },
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
      ),
    );
  }
}
