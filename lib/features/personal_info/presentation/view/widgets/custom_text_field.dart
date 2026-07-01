import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String? initialValue;
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isDisabled;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.initialValue,
    this.label,
    this.hintText,
    this.controller,
    this.isReadOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.isDisabled = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final isDark = context.isDark;
    final disabledColor =
        isDark ? ext.cardBorder.withOpacity(0.55) : Colors.grey.shade200;
    final fieldColor = isDisabled ? disabledColor : ext.cardColor;
    final textColor =
        isDisabled ? ext.subtleText : Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                color: ext.subtleText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextFormField(
          inputFormatters: inputFormatters ?? [],
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: isReadOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          cursorColor: isDisabled ? Colors.grey : AppColors.greenStart,
          style: TextStyle(color: textColor, fontSize: 15),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: ext.subtleText.withOpacity(0.7)),
            filled: true,
            fillColor: fieldColor,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color:
                    isDisabled
                        ? ext.cardBorder
                        : AppColors.greenStart.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color:
                    isDisabled
                        ? ext.cardBorder
                        : AppColors.greenStart.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: isDisabled ? ext.cardBorder : AppColors.greenStart,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
