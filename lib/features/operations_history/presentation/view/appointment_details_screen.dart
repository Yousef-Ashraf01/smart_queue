import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/appointment_details_cubit.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/feedback_cubit.dart';
import 'package:timezone/timezone.dart' as tz;

class AppointmentDetailsScreen extends StatefulWidget {
  final int id;

  const AppointmentDetailsScreen({super.key, required this.id});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentDetailsCubit>().fetchById(widget.id);
    context.read<FeedbackCubit>().loadFeedback(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "appointment_details".tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              Expanded(
                child: BlocConsumer<
                  AppointmentDetailsCubit,
                  AppointmentDetailsState
                >(
                  listener: (context, state) {
                    if (state is AppointmentDeleted) {
                      AppFlushbar.show(
                        context,
                        message: "appointment_deleted_success".tr(),
                        type: MessageType.success,
                        duration: const Duration(milliseconds: 1500),
                      );

                      Future.delayed(const Duration(milliseconds: 1500), () {
                        if (context.mounted) {
                          context.pop(true);
                        }
                      });
                    }

                    if (state is AppointmentDetailsError) {
                      AppFlushbar.show(
                        context,
                        message: state.message.localizedApi,
                        type: MessageType.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    final cubit = context.read<AppointmentDetailsCubit>();

                    AppointmentResponseModel? item;

                    if (state is AppointmentDetailsLoaded) {
                      item = state.appointment;
                    } else if (state is AppointmentDeleting) {
                      final currentState = cubit.state;
                      if (currentState is AppointmentDetailsLoaded) {
                        item = currentState.appointment;
                      }
                    }

                    if (state is AppointmentDetailsLoading) {
                      return _buildSkeleton();
                    }

                    if (state is AppointmentDeleted) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green[200],
                        ),
                      );
                    }

                    if (item == null) {
                      return const SizedBox();
                    }

                    return Stack(
                      children: [
                        _buildContent(item),

                        if (state is AppointmentDeleting)
                          Container(
                            color: Colors.black.withOpacity(0.2),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(width: 120, height: 14, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 80, height: 12, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppointmentResponseModel item) {
    final duration = _getDuration(item.startTime, item.endTime);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero Card ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff1A9E7A), Color(0xff0F6E56)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.counter.service.name.localizedApi,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Appointment #${item.id}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 16),

                // Date + Time row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _heroChip(Icons.calendar_today_outlined, item.date),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _heroChip(
                        Icons.access_time,
                        "${_fmt(item.startTime)} - ${_fmt(item.endTime)}",
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _heroChip(
                        Icons.timer_outlined,
                        "${duration.inMinutes} min",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // بعد الـ Hero Card مباشرة
          if (item.canceled || item.missed) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    item.canceled
                        ? const Color(0xffFCEBEB)
                        : const Color(0xffFAEEDA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    item.canceled
                        ? Icons.cancel_outlined
                        : Icons.access_time_filled,
                    color:
                        item.canceled
                            ? const Color(0xffA32D2D)
                            : const Color(0xff854F0B),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.canceled
                        ? "appointment_cancelled_status".tr()
                        : "appointment_missed_status".tr(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          item.canceled
                              ? const Color(0xffA32D2D)
                              : const Color(0xff854F0B),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Service Info ──────────────────────────────────────────────
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("service_details".tr()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xffE1F5EE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.miscellaneous_services_outlined,
                        color: Color(0xff0F6E56),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.counter.service.name.localizedApi,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.counter.service.description.localizedApi,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade100),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailRow(
                      Icons.payments_outlined,
                      "amount".tr(),
                      "${item.counter.service.price} ${item.counter.service.currency}",
                    ),
                    if (item.paymentMethod?.toUpperCase() == 'CASH')
                      _cashBadge()
                    else
                      _onlineBadge(),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _sectionCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        item.wantReminder
                            ? const Color(0xffFFF8E1)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.wantReminder
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_off_outlined,
                    color: item.wantReminder ? Colors.orange : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item.wantReminder
                      ? "reminder_on".tr()
                      : "no_reminder_set".tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: item.wantReminder ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _buildFeedbackSection(item),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: "delete".tr(),
                  icon: Icons.delete_outline,
                  bgColor: const Color(0xffFCEBEB),
                  textColor: const Color(0xffA32D2D),
                  onTap: _showDeleteDialog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  label: "edit".tr(),
                  icon: Icons.edit_outlined,
                  bgColor:
                      _canEdit(item)
                          ? const Color(0xffE1F5EE)
                          : Colors.grey.shade200,
                  textColor:
                      _canEdit(item) ? const Color(0xff085041) : Colors.grey,
                  onTap:
                      _canEdit(item)
                          ? () async {
                            final updated = await context.push(
                              AppRoutes.updateAppointment,
                              extra: item,
                            );
                            if (updated != null &&
                                updated is AppointmentResponseModel) {
                              context.read<AppointmentDetailsCubit>().emit(
                                AppointmentDetailsLoaded(updated),
                              );
                              await _updateCalendarEvent(updated);
                            }
                          }
                          : () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _canEdit(AppointmentResponseModel item) {
    if (item.canceled || item.missed) return false;

    try {
      final dateParts = item.date.split("-");
      final timeParts = item.startTime.split(":");
      final appointmentDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      return DateTime.now().isBefore(appointmentDateTime);
    } catch (_) {
      return false;
    }
  }

  Widget _heroChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFeedbackSection(AppointmentResponseModel item) {
    final now = DateTime.now();
    final bool isPast = _isInPast(item);
    final bool isActive = !item.canceled && !item.missed;

    if (!isPast && isActive) {
      return _sectionCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffFFF8E1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.pending_actions_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "appointment_pending".tr(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (isPast && isActive) {
      return BlocConsumer<FeedbackCubit, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackError) {
            AppFlushbar.show(
              context,
              message: state.message.localizedApi,
              type: MessageType.error,
            );
          }
          if (state is FeedbackSubmitted) {
            AppFlushbar.show(
              context,
              message: "feedback_submitted_success".tr(),
              type: MessageType.success,
            );

            context.read<FeedbackCubit>().loadFeedback(item.id);
          }
        },
        builder: (context, state) {
          if (state is FeedbackLoaded && state.feedbacks.isNotEmpty) {
            return _feedbackDisplay(state.feedbacks.first.feedback);
          }

          return _feedbackForm(item.id, state);
        },
      );
    }

    return const SizedBox();
  }

  Widget _feedbackDisplay(String feedbackText) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel("your_feedback".tr()),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE1F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.rate_review_outlined,
                  color: Color(0xff0F6E56),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "completed".tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff0F6E56),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feedbackText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _onlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.credit_card_rounded, size: 13, color: Color(0xFF8B5CF6)),
          SizedBox(width: 4),
          Text(
            "Online",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackForm(int appointmentId, FeedbackState state) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE1F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xff0F6E56),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Appointment Completed",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff0F6E56),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _FeedbackFormWidget(
            appointmentId: appointmentId,
            isSubmitting: state is FeedbackSubmitting,
          ),
        ],
      ),
    );
  }

  bool _isInPast(AppointmentResponseModel item) {
    try {
      final dateParts = item.date.split("-");
      final timeParts = item.endTime.split(":");
      final endDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      return DateTime.now().isAfter(endDateTime);
    } catch (_) {
      return false;
    }
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff0F6E56),
          ),
        ),
      ],
    );
  }

  Widget _paymentBadge(bool paid) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: paid ? const Color(0xffE1F5EE) : const Color(0xffFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            paid ? Icons.check_circle_outline : Icons.pending_outlined,
            size: 13,
            color: paid ? const Color(0xff0F6E56) : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            paid ? "Paid" : "Unpaid",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: paid ? const Color(0xff0F6E56) : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cashBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.payments_rounded,
            size: 13,
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(width: 4),
          Text(
            "cash".tr(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  String _paymentMethodLabel(String? method) {
    switch (method?.toUpperCase()) {
      case 'CASH':
        return 'cash'.tr();
      case 'ONLINE':
      case 'STRIPE':
        return 'online'.tr();
      default:
        return 'not_specified'.tr();
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
        return Icons.help_outline_rounded;
    }
  }

  // "08:00:00" → "08:00"
  String _fmt(String time) {
    final parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> _updateCalendarEvent(
    AppointmentResponseModel appointment,
  ) async {
    final permissionResult = await _deviceCalendarPlugin.hasPermissions();
    bool granted = permissionResult.data ?? false;

    if (!granted) {
      final result = await _deviceCalendarPlugin.requestPermissions();
      granted = result.data ?? false;
    }

    if (!granted) return;

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    final calendars = calendarsResult.data;
    if (calendars == null || calendars.isEmpty) return;

    final calendarId = calendars.first.id;

    final dateParts = appointment.date.split("-");
    final startParts = appointment.startTime.split(":");
    final endParts = appointment.endTime.split(":");

    final start = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );

    final end = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    final event = Event(
      calendarId,
      title: appointment.counter.service.name.localizedApi,
      description: appointment.counter.service.description.localizedApi,
      start: tz.TZDateTime.from(start, tz.local),
      end: tz.TZDateTime.from(end, tz.local),
    );

    event.eventId =
        "${appointment.counter.service.id}-${start.toIso8601String()}";

    await _deviceCalendarPlugin.createOrUpdateEvent(event);
  }

  Widget _serviceCard(ServiceModel service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "service_label".tr(),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            service.name.localizedApi,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            service.description.localizedApi,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "price".tr(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "${service.price}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff0F6E56),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AppointmentDetailsCubit>(),
          child: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
            builder: (context, state) {
              final isDeleting = state is AppointmentDeleting;

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Icon ──────────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          color: Color(0xffFCEBEB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xffA32D2D),
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Title ─────────────────────────────────────────
                      Text(
                        "delete_appointment".tr(),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtitle ──────────────────────────────────────
                      Text(
                        "delete_appointment_confirm".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Buttons ───────────────────────────────────────
                      Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  isDeleting
                                      ? null
                                      : () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    "cancel".tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Delete
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  isDeleting
                                      ? null
                                      : () {
                                        context.pop();
                                        context
                                            .read<AppointmentDetailsCubit>()
                                            .delete(widget.id);
                                      },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xffA32D2D),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child:
                                      isDeleting
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                          : Text(
                                            "delete".tr(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Duration _getDuration(String start, String end) {
    final startParts = start.split(":");
    final endParts = end.split(":");

    final startDate = DateTime(
      0,
      0,
      0,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );

    final endDate = DateTime(
      0,
      0,
      0,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    return endDate.difference(startDate);
  }
}

class _FeedbackFormWidget extends StatefulWidget {
  final int appointmentId;
  final bool isSubmitting;

  const _FeedbackFormWidget({
    required this.appointmentId,
    required this.isSubmitting,
  });

  @override
  State<_FeedbackFormWidget> createState() => _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends State<_FeedbackFormWidget> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        _sectionLabel("rate_your_experience".tr()),
        const SizedBox(height: 12),
        Center(
          child: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 36,
            unratedColor: Colors.grey.shade200,
            itemBuilder:
                (context, _) =>
                    const Icon(Icons.star_rounded, color: Color(0xff0F6E56)),
            onRatingUpdate: (rating) {
              setState(() => _rating = rating);
            },
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap:
              widget.isSubmitting || _rating == 0
                  ? null
                  : () {
                    context.read<FeedbackCubit>().submitFeedback(
                      appointmentId: widget.appointmentId,
                      feedback: _rating.toInt().toString(),
                    );
                  },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color:
                  _rating == 0 ? Colors.grey.shade300 : const Color(0xff0F6E56),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child:
                  widget.isSubmitting
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        "submit_feedback".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
