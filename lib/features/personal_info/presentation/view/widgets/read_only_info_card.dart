import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class ReadOnlyInfoCard extends StatelessWidget {
  final List<InfoItem> items;
  const ReadOnlyInfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: ext.cardColor.withOpacity(context.isDark ? 0.92 : 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.25)),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(item.icon, size: 20, color: primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: ext.subtleText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value.isEmpty ? '—' : item.value,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  indent: 48,
                  color: primary.withOpacity(0.15),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
