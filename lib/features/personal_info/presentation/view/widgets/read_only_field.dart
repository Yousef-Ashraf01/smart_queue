import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';

class ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: ext.cardColor.withOpacity(context.isDark ? 0.92 : 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.25)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.lock_outline, size: 16, color: ext.subtleText),
            ],
          ),
        ),
      ],
    );
  }
}
