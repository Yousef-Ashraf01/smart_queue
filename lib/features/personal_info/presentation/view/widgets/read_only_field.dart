import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00BFA6).withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF00BFA6)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2D2D2D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: Color(0xFF8E8E93),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
