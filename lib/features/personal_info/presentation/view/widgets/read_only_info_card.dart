import 'package:flutter/material.dart';

class ReadOnlyInfoCard extends StatelessWidget {
  final List<InfoItem> items;
  const ReadOnlyInfoCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00BFA6).withOpacity(0.2)),
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
                    Icon(item.icon, size: 20, color: const Color(0xFF00BFA6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value.isEmpty ? '—' : item.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D2D2D),
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
                  color: const Color(0xFF00BFA6).withOpacity(0.15),
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
