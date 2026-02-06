import 'package:flutter/material.dart';
import 'custom_text_field.dart';


class DateFieldsGroup extends StatelessWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final VoidCallback onTap;

  const DateFieldsGroup({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDateTile("Day", dayController),
        const SizedBox(width: 10),
        _buildDateTile("Month", monthController),
        const SizedBox(width: 10),
        _buildDateTile("Year", yearController),
      ],
    );
  }

  Widget _buildDateTile(String hint, TextEditingController controller) {
    return Expanded(
      child: CustomTextField(
        hintText: hint,
        controller: controller,
        isReadOnly: true,
        onTap: onTap,
      ),
    );
  }
}