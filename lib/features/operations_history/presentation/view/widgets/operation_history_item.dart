import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
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

  // Determine the appointment status
  _AppointmentStatus get _status {
    if (item.canceled) return _AppointmentStatus.cancelled;
    if (item.missed) return _AppointmentStatus.missed;
    // Check if the date is in the past
    try {
      final appointmentDate = DateTime.parse(item.date);
      if (appointmentDate.isBefore(
        DateTime.now().subtract(const Duration(days: 1)),
      )) {
        return _AppointmentStatus.completed;
      }
    } catch (_) {}
    return _AppointmentStatus.upcoming;
  }

  String _paymentMethodLabel(String? method) {
    switch (method?.toUpperCase()) {
      case 'CASH':
        return 'cash'.tr();
      case 'ONLINE':
      case 'STRIPE':
        return 'online'.tr();
      default:
        return 'unpaid'.tr();
    }
  }

  IconData _paymentMethodIcon(String? method) {
    switch (method?.toUpperCase()) {
      case 'CASH':
        return Icons.payments_rounded;
      case 'ONLINE':
      case 'STRIPE':
        return Icons.credit_card_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  Color _paymentMethodColor(String? method) {
    switch (method?.toUpperCase()) {
      case 'CASH':
        return const Color(0xFF3B82F6); // أزرق للكاش
      case 'ONLINE':
      case 'STRIPE':
        return const Color(0xFF8B5CF6); // بنفسجي للأونلاين
      default:
        return const Color(0xFFF59E0B); // أصفر لـ unpaid
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final ext = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: status.color.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: ext.cardColor.withOpacity(0.88),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ext.cardBorder.withOpacity(0.6),
                width: 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // ── Color accent bar ─────────────────────
                  Container(
                    width: 4.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [status.color, status.color.withOpacity(0.6)],
                      ),
                    ),
                  ),

                  // ── Card content ─────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Header row ──────────────────
                          Row(
                            children: [
                              // Service icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      status.color.withOpacity(0.15),
                                      status.color.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  _serviceIcon,
                                  color: status.color,
                                  size: 22,
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Service name + description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.counter.service.name.localizedApi,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                        letterSpacing: -0.2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item
                                          .counter
                                          .service
                                          .description
                                          .localizedApi,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ext.subtleText.withOpacity(0.8),
                                        height: 1.2,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Status badge
                              _StatusChip(status: status),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ── Divider ─────────────────────
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ext.subtleText.withOpacity(0.2),
                                  ext.subtleText.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Info row ────────────────────
                          Row(
                            children: [
                              // Date chip
                              _InfoPill(
                                icon: Icons.calendar_today_rounded,
                                label: _formatDate(item.date),
                                color: const Color(0xFF5B6BF5),
                              ),

                              const SizedBox(width: 8),

                              // Time chip
                              _InfoPill(
                                icon: Icons.schedule_rounded,
                                label:
                                    "${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}",
                                color: const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // ── Footer row ─────────────────
                          Row(
                            children: [
                              // Payment status
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      item.paid == true
                                          ? const Color(
                                            0xFF10B981,
                                          ).withOpacity(0.08)
                                          : _paymentMethodColor(
                                            item.paymentMethod,
                                          ).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      item.paid == true
                                          ? Icons.check_circle_rounded
                                          : _paymentMethodIcon(
                                            item.paymentMethod,
                                          ),
                                      size: 14,
                                      color:
                                          item.paid == true
                                              ? const Color(0xFF10B981)
                                              : _paymentMethodColor(
                                                item.paymentMethod,
                                              ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.paid == true
                                          ? "paid".tr()
                                          : _paymentMethodLabel(
                                            item.paymentMethod,
                                          ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            item.paid == true
                                                ? const Color(0xFF10B981)
                                                : _paymentMethodColor(
                                                  item.paymentMethod,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Price tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF10B981).withOpacity(0.12),
                                      const Color(0xFF34D399).withOpacity(0.08),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${item.counter.service.price} ${item.counter.service.currency}",
                                  style: const TextStyle(
                                    color: Color(0xFF059669),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Bookmark button
                              GestureDetector(
                                onTap: onBookmarkTap,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color:
                                        isBookmarked
                                            ? const Color(
                                              0xFF10B981,
                                            ).withOpacity(0.1)
                                            : ext.subtleText.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isBookmarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_outline_rounded,
                                    size: 20,
                                    color:
                                        isBookmarked
                                            ? const Color(0xFF10B981)
                                            : ext.subtleText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData get _serviceIcon {
    final name = item.counter.service.name.toLowerCase();
    if (name.contains('consult')) return Icons.medical_services_outlined;
    if (name.contains('payment') || name.contains('pay'))
      return Icons.payment_outlined;
    if (name.contains('transfer')) return Icons.swap_horiz_outlined;
    if (name.contains('deposit')) return Icons.account_balance_wallet_outlined;
    if (name.contains('withdraw')) return Icons.money_off_outlined;
    if (name.contains('loan')) return Icons.request_page_outlined;
    if (name.contains('card')) return Icons.credit_card_outlined;
    if (name.contains('account')) return Icons.account_balance_outlined;
    return Icons.receipt_long_outlined;
  }

  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return "";
    final parts = time.split(':');
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return "$h12:$minute ${period.localizedApi}";
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "";
    try {
      final d = DateTime.parse(date);
      final months = [
        '',
        'month_jan'.tr(),
        'month_feb'.tr(),
        'month_mar'.tr(),
        'month_apr'.tr(),
        'month_may'.tr(),
        'month_jun'.tr(),
        'month_jul'.tr(),
        'month_aug'.tr(),
        'month_sep'.tr(),
        'month_oct'.tr(),
        'month_nov'.tr(),
        'month_dec'.tr(),
      ];
      return "${d.day} ${months[d.month]} ${d.year}";
    } catch (_) {
      return date;
    }
  }
}

// ── Status Enum ──────────────────────────────────────────────────────
enum _AppointmentStatus {
  upcoming(
    label: "upcoming",
    color: Color(0xFF3B82F6),
    icon: Icons.event_available_rounded,
  ),
  completed(
    label: "completed",
    color: Color(0xFF10B981),
    icon: Icons.check_circle_outline_rounded,
  ),
  cancelled(
    label: "cancelled",
    color: Color(0xFFEF4444),
    icon: Icons.cancel_outlined,
  ),
  missed(
    label: "missed",
    color: Color(0xFFF59E0B),
    icon: Icons.warning_amber_rounded,
  );

  final String label;
  final Color color;
  final IconData icon;

  const _AppointmentStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

// ── Status Chip ──────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final _AppointmentStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label.tr(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: status.color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Pill ─────────────────────────────────────────────────────────
class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.withOpacity(0.7)),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
