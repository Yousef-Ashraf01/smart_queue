import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CustomPickerField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? valueText;
  final VoidCallback onTap;

  const CustomPickerField({
    super.key,
    required this.hint,
    required this.icon,
    required this.valueText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = valueText != null && valueText!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                // Green-tinted icon container
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tealLight.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.teal,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                // Text content
                Expanded(
                  child: Text(
                    hasValue ? valueText! : hint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                      color: hasValue ? AppColors.blackColor : Colors.grey.shade500,
                      fontFamily: 'Inter Tight',
                    ),
                  ),
                ),
                // Trailing Arrow indicator
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

