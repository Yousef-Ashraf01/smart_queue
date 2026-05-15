import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';

class CustomDropdown extends StatelessWidget {
  final ServiceCounterModel? value;
  final List<ServiceCounterModel> items;
  final String hint;
  final void Function(ServiceCounterModel?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.whiteColor),
      ),
      child: DropdownButton<ServiceCounterModel>(
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint),
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_sharp),

        selectedItemBuilder: (context) {
          return items.map((e) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(e.serviceName, overflow: TextOverflow.ellipsis),
            );
          }).toList();
        },

        items:
            items.map((item) {
              return DropdownMenuItem<ServiceCounterModel>(
                value: item,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.serviceName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.serviceDescription,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${item.servicePrice}"),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color:
                                    item.isOperational
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (item != items.last) const Divider(height: 1),
                  ],
                ),
              );
            }).toList(),

        onChanged: onChanged,
      ),
    );
  }
}
