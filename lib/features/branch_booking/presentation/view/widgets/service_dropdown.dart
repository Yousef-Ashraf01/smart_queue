import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';

class ServiceDropdown extends StatelessWidget {
  final ServiceCounterModel? selectedService;

  const ServiceDropdown({super.key, this.selectedService});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.whiteColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedService?.serviceName ?? "Select a service",
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),
          const Icon(Icons.keyboard_arrow_down_sharp),
        ],
      ),
    );
  }
}
