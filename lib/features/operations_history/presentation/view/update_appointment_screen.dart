import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/appointment_details_cubit.dart';

import '../../../../core/di/service_locator.dart';

class UpdateAppointmentScreen extends StatefulWidget {
  final AppointmentResponseModel appointment;

  const UpdateAppointmentScreen({super.key, required this.appointment});

  @override
  State<UpdateAppointmentScreen> createState() =>
      _UpdateAppointmentScreenState();
}

class _UpdateAppointmentScreenState extends State<UpdateAppointmentScreen> {
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  ServiceModel? selectedService;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    selectedService = widget.appointment.counter.service;

    dateController = TextEditingController(text: widget.appointment.date);
    startTimeController = TextEditingController(
      text: widget.appointment.startTime,
    );
    endTimeController = TextEditingController(text: widget.appointment.endTime);
  }

  @override
  void dispose() {
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  bool _isCheckingDate = false;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff3CC572),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xff3CC572)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final dateStr = picked.toIso8601String().split("T").first;
      await _validateAndSetDate(dateStr);
    }
  }

  Future<void> _validateAndSetDate(String dateStr) async {
    setState(() => _isCheckingDate = true);

    final result = await sl<BookingRepository>().getAvailableSlots(
      counterId: widget.appointment.counter.id,
      date: dateStr,
    );

    if (!mounted) return;
    setState(() => _isCheckingDate = false);

    result.fold(
      (failure) {
        // 400 = past date
        AppFlushbar.show(
          context,
          message: "cannot_select_past_date".tr(),
          type: MessageType.error,
        );
      },
      (slots) {
        if (slots.isEmpty) {
          // holiday or no slots
          AppFlushbar.show(
            context,
            message: "no_available_slots".tr(),
            type: MessageType.warning,
          );
        } else {
          setState(() => dateController.text = dateStr);
        }
      },
    );
  }

  String formatTime(String time) {
    try {
      final parts = time.split(":");
      final dateTime = DateTime(
        0,
        0,
        0,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return time;
    }
  }

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: parseTime(startTimeController.text),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff3CC572),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            timePickerTheme: const TimePickerThemeData(
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              dayPeriodTextColor: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      final endDateTime = startDateTime.add(const Duration(minutes: 15));

      setState(() {
        startTimeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:"
            "${picked.minute.toString().padLeft(2, '0')}:00";

        endTimeController.text =
            "${endDateTime.hour.toString().padLeft(2, '0')}:"
            "${endDateTime.minute.toString().padLeft(2, '0')}:00";
      });
    }
  }

  TimeOfDay parseTime(String time) {
    try {
      if (time.contains(":") && time.contains(" ")) {
        final dateTime = DateFormat.jm().parse(time);
        return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      } else {
        final parts = time.split(":");
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      return TimeOfDay.now();
    }
  }

  void updateAppointment() async {
    if (dateController.text == widget.appointment.date &&
        startTimeController.text == widget.appointment.startTime &&
        endTimeController.text == widget.appointment.endTime) {
      AppFlushbar.show(
        context,
        message: "no_changes_made".tr(),
        type: MessageType.warning,
      );
      return;
    }

    if (dateController.text != widget.appointment.date) {
      setState(() => _isCheckingDate = true);

      final result = await sl<BookingRepository>().getAvailableSlots(
        counterId: widget.appointment.counter.id,
        date: dateController.text,
      );

      if (!mounted) return;
      setState(() => _isCheckingDate = false);

      bool canProceed = false;

      result.fold(
        (failure) {
          AppFlushbar.show(
            context,
            message: "cannot_select_past_date".tr(),
            type: MessageType.error,
          );
        },
        (slots) {
          if (slots.isEmpty) {
            AppFlushbar.show(
              context,
              message: "no_available_slots".tr(),
              type: MessageType.warning,
            );
          } else {
            canProceed = true;
          }
        },
      );

      if (!canProceed) return;
    }

    setState(() => _isUpdating = true);

    final updated = widget.appointment.copyWith(
      date: dateController.text,
      startTime: startTimeController.text,
    );

    context.read<AppointmentDetailsCubit>().update(
      widget.appointment.id,
      updated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
      listener: (context, state) {
        if (state is AppointmentDetailsLoaded && _isUpdating) {
          AppFlushbar.show(
            context,
            message: "appointment_updated_success".tr(),
            type: MessageType.success,
            duration: const Duration(milliseconds: 1500),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              context.pop(state.appointment);
            }
          });
        }

        if (state is AppointmentDetailsError) {
          setState(() => _isUpdating = false);
          AppFlushbar.show(
            context,
            message: state.message.localizedApi,
            type: MessageType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = _isUpdating || _isCheckingDate;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ext.bgGradientTop, ext.bgGradientBottom],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "update_appointment_title".tr(),
                      style: AppStyle.appBarTitle.adaptive(context),
                    ),

                    const SizedBox(height: 20),

                    Expanded(child: _buildContent()),
                  ],
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00BFA6)),
                  ),
                ),
            ],
          ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: isLoading ? null : updateAppointment,
              child:
                  isLoading
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green[200],
                        ),
                      )
                      : Text(
                        "save_changes_btn".tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header Card ───────────────────────────────────────────────
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
                    Icons.edit_calendar_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.appointment.counter.service.name.localizedApi,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "appointment_hash".tr(
                    args: [widget.appointment.id.toString()],
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Date & Time ───────────────────────────────────────────────
          _sectionLabel("schedule_label".tr()),
          const SizedBox(height: 10),

          _inputCard(
            label: "date_label".tr(),
            value: dateController.text,
            icon: Icons.calendar_today_outlined,
            onTap: pickDate,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _inputCard(
                  label: "start_time_label".tr(),
                  value: startTimeController.text,
                  icon: Icons.access_time,
                  onTap: pickStartTime,
                  isTime: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Opacity(
                  opacity: 0.6,
                  child: _inputCard(
                    label: "end_time_label".tr(),
                    value: endTimeController.text,
                    icon: Icons.access_time_filled_outlined,
                    showEditIcon: false,
                    onTap: () {},
                    isTime: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Service ───────────────────────────────────────────────────
          _sectionLabel("service_label".tr()),
          const SizedBox(height: 10),
          _serviceCard(widget.appointment.counter.service),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: context.appTheme.subtleText,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _inputCard({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    bool isTime = false,
    bool showEditIcon = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appTheme.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xff0F6E56)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.appTheme.subtleText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty
                        ? "select_label".tr(args: [label])
                        : (isTime ? formatTime(value) : value),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (showEditIcon)
              Icon(Icons.edit, size: 18, color: context.appTheme.subtleText),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(ServiceModel service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.18 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffE1F5EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.miscellaneous_services_outlined,
              color: Color(0xff0F6E56),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appTheme.subtleText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE1F5EE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${service.price} EGP",
              style: const TextStyle(
                color: Color(0xff0F6E56),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
