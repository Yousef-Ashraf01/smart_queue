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
  final bool isDisabled;

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
    this.isDisabled = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    // ✅ لو readOnly → شكل مختلف خالص
    if (widget.readOnly) {
      return _buildReadOnlyField();
    }

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
          style: TextStyle(
            color: widget.isDisabled ? Colors.grey : Colors.black,
            fontSize: 15,
          ),
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
                      onPressed:
                          widget.isDisabled
                              ? null
                              : () => setState(() => _obscure = !_obscure),
                    )
                    : null,
            filled: true,
            fillColor: widget.isDisabled ? Colors.grey.shade200 : Colors.white,
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

  // ✅ شكل الـ read-only field - بيبان كـ info card مش text field
  Widget _buildReadOnlyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Label + "From ID" badge ────────────────────────────
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  118,
                  226,
                  136,
                ).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.3),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 11,
                    color: const Color.fromARGB(255, 11, 58, 30),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'From ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 11, 58, 30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ─── Info card ───────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 118, 226, 136).withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // أيقونة
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 20,
                  color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.6),
                ),
              if (widget.icon != null) const SizedBox(width: 12),

              // القيمة
              Expanded(
                child: Text(
                  widget.controller.text.isEmpty ? '—' : widget.controller.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 11, 58, 30),
                  ),
                ),
              ),

              // lock icon في الآخر
              Icon(Icons.lock_rounded, size: 15, color: Colors.grey.shade400),
            ],
          ),
        ),

        SizedBox(height: widget.height ?? 18),
      ],
    );
  }
}
