import 'package:flutter/material.dart';

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
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: valueText ?? ''),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xff3CC572)),
        ),
      ),
      onTap: onTap,
    );
  }
}
