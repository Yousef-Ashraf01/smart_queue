import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? icon;
  final FocusNode? focusNode;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final double? height;

  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.icon,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          cursorColor: AppColors.greenStart,
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscure = !_obscure);
                      },
                    )
                    : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: widget.height ?? 18),
      ],
    );
  }
}
