import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;

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
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.whiteColor),
      ),
      child: DropdownButton<String>(
        icon: Icon(Icons.keyboard_arrow_down_sharp),
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(hint),
        value: value,
        items:
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
