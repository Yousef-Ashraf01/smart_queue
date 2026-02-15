import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/operations_history/presentation/view/widgets/operation_history_item.dart';

class OperationsHistoryScreen extends StatelessWidget {
  const OperationsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: NotificationWidget(),
                ),
              ),
              SizedBox(height: 15),
              Text("Operations History", style: AppStyle.bold24black),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 4, bottom: 40),
                  itemCount: 5,
                  itemBuilder: (context, index) => OperationHistoryItem(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
