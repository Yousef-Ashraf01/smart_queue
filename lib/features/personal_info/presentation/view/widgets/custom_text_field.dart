import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          readOnly: isReadOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          cursorColor: AppColors.greenStart,
          style: const TextStyle(color: Colors.black, fontSize: 15),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFC7C7CC)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
