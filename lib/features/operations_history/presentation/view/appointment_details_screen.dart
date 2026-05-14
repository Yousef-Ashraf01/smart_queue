import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/appointment_details_cubit.dart';
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
              const Text(
                "Appointment Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        message: "Appointment deleted successfully",
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
                        message: state.message,
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
                  item.counter.service.name,
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

          const SizedBox(height: 16),

          // ── Service Info ──────────────────────────────────────────────
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel("Service Details"),
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
                            item.counter.service.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.counter.service.description,
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
                      "Amount",
                      "${item.amountToPay} ${item.counter.service.currency}",
                    ),
                    _paymentBadge(item.paid),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Reminder ──────────────────────────────────────────────────
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
                  item.wantReminder ? "Reminder is on" : "No reminder set",
                  style: TextStyle(
                    fontSize: 14,
                    color: item.wantReminder ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Actions ───────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  label: "Delete",
                  icon: Icons.delete_outline,
                  bgColor: const Color(0xffFCEBEB),
                  textColor: const Color(0xffA32D2D),
                  onTap: _showDeleteDialog,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  label: "Edit",
                  icon: Icons.edit_outlined,
                  bgColor: const Color(0xffE1F5EE),
                  textColor: const Color(0xff085041),
                  onTap: () async {
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
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────────

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
      title: appointment.counter.service.name,
      description: appointment.counter.service.description,
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
          const Text(
            "Service",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            service.description,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price",
                style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      const Text(
                        "Delete Appointment",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtitle ──────────────────────────────────────
                      Text(
                        "Are you sure you want to delete this appointment?\nThis action cannot be undone.",
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
                                    "Cancel",
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
                                          : const Text(
                                            "Delete",
                                            style: TextStyle(
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
