import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

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
    if (widget.readOnly) {
      return _buildReadOnlyField();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
            color:
                widget.isDisabled
                    ? context.appTheme.subtleText
                    : Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
          ),
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: context.appTheme.subtleText.withOpacity(0.7),
            ),
            prefixIcon:
                widget.icon != null
                    ? Icon(widget.icon, color: context.appTheme.subtleText)
                    : null,
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
            fillColor:
                widget.isDisabled
                    ? context.appTheme.cardBorder.withOpacity(
                      context.isDark ? 0.55 : 0.18,
                    )
                    : context.appTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: AppColors.greenStart.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: AppColors.greenStart.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: AppColors.greenStart, width: 1.4),
            ),
          ),
        ),
        SizedBox(height: widget.height ?? 18),
      ],
    );
  }

  Widget _buildReadOnlyField() {
    final isDark = context.isDark;
    final primaryGreen =
        isDark ? Colors.green[300]! : const Color.fromARGB(255, 11, 58, 30);
    final bgGreen =
        isDark
            ? Colors.green[900]!.withOpacity(0.25)
            : const Color.fromARGB(255, 118, 226, 136).withOpacity(0.08);
    final borderGreen =
        isDark
            ? Colors.green[800]!.withOpacity(0.4)
            : const Color.fromARGB(255, 11, 58, 30).withOpacity(0.15);
    final badgeBg =
        isDark
            ? Colors.green[900]!.withOpacity(0.4)
            : const Color.fromARGB(255, 118, 226, 136).withOpacity(0.2);
    final badgeBorder =
        isDark
            ? Colors.green[800]!.withOpacity(0.6)
            : const Color.fromARGB(255, 11, 58, 30).withOpacity(0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Label + "From ID" badge ────────────────────────────
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: badgeBorder, width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 11, color: primaryGreen),
                  const SizedBox(width: 3),
                  Text(
                    'From ID',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: primaryGreen,
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
            color: bgGreen,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderGreen, width: 1),
          ),
          child: Row(
            children: [
              // أيقونة
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 20,
                  color: primaryGreen.withOpacity(0.7),
                ),
              if (widget.icon != null) const SizedBox(width: 12),

              // القيمة
              Expanded(
                child: Text(
                  widget.controller.text.isEmpty ? '—' : widget.controller.text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: primaryGreen,
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
