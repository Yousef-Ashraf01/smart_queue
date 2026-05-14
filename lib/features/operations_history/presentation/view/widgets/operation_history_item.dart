import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';

class OperationHistoryItem extends StatelessWidget {
  final AppointmentResponseModel item;
  final VoidCallback? onTap;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const OperationHistoryItem({
    super.key,
    required this.item,
    this.onTap,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: Service name + bookmark ──────────────────────
            Row(
              children: [
                // أيقونة الخدمة
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff3CC572).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xff3CC572),
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.counter.service.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.counter.service.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 24,
                    color: isBookmarked ? const Color(0xff3CC572) : Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, thickness: 1),
            const SizedBox(height: 10),

            // ── Details ───────────────────────────────────────────────
            Row(
              children: [
                // Date
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label: item.date ?? "",
                ),

                const SizedBox(width: 10),

                // Time
                _InfoChip(
                  icon: Icons.access_time,
                  label:
                      _formatTime(item.startTime) +
                      " - " +
                      _formatTime(item.endTime),
                ),

                const Spacer(),

                // Price
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff3CC572).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${item.amountToPay} EGP",
                    style: const TextStyle(
                      color: Color(0xff3CC572),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Paid status ───────────────────────────────────────────
            Row(
              children: [
                Icon(
                  item.paid == true
                      ? Icons.check_circle_outline
                      : Icons.pending_outlined,
                  size: 15,
                  color: item.paid == true ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  item.paid == true ? "Paid" : "Unpaid",
                  style: TextStyle(
                    fontSize: 12,
                    color: item.paid == true ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // "08:00:00" → "08:00"
  String _formatTime(String? time) {
    if (time == null) return "";
    final parts = time.split(':');
    if (parts.length < 2) return time;
    return "${parts[0]}:${parts[1]}";
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
