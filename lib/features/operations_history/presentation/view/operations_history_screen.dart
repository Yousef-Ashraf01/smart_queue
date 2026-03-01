import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_history_item.dart';

class OperationsHistoryScreen extends StatelessWidget {
  const OperationsHistoryScreen({super.key});

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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  children: const [
                    OperationHistoryItem(
                      title: 'National Postal Authority',
                      location: 'Helwan, Cairo, Egypt',
                      date: '7/6/2025',
                      imageAsset: AppAssets.imagePostal,
                    ),
                    OperationHistoryItem(
                      title: 'Civil Affairs Sector',
                      location: 'Helwan, Cairo, Egypt',
                      date: '12/6/2025',
                      imageAsset: AppAssets.imagePostal,
                    ),
                    OperationHistoryItem(
                      title:
                          'General Administration of Passports and Nationality',
                      location: 'Helwan, Cairo, Egypt',
                      date: '18/5/2025',
                      imageAsset: AppAssets.imagePostal,
                    ),
                    OperationHistoryItem(
                      title: 'General Traffic Department',
                      location: 'Helwan, Cairo, Egypt',
                      date: '5/6/2025',
                      imageAsset: AppAssets.imagePostal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
