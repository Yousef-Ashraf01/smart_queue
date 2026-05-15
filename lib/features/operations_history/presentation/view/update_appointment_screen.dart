import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/appointment_details_cubit.dart';

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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.appointment.date),
      firstDate: DateTime(2000),
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
      setState(() {
        dateController.text = picked.toIso8601String().split("T").first;
      });
    }
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

  void updateAppointment() {
    if (dateController.text == widget.appointment.date &&
        startTimeController.text == widget.appointment.startTime &&
        endTimeController.text == widget.appointment.endTime) {
      AppFlushbar.show(
        context,
        message: "No changes made!",
        type: MessageType.warning,
      );
      return;
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
    return BlocConsumer<AppointmentDetailsCubit, AppointmentDetailsState>(
      listener: (context, state) {
        if (state is AppointmentDetailsLoaded && _isUpdating) {
          AppFlushbar.show(
            context,
            message: "Appointment updated successfully!",
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
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = _isUpdating;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text("Update Appointment", style: AppStyle.appBarTitle),

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
                      : const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
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
                  widget.appointment.counter.service.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Appointment #${widget.appointment.id}",
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
          _sectionLabel("Schedule"),
          const SizedBox(height: 10),

          _inputCard(
            label: "Date",
            value: dateController.text,
            icon: Icons.calendar_today_outlined,
            onTap: pickDate,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _inputCard(
                  label: "Start Time",
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
                    label: "End Time",
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
          _sectionLabel("Service"),
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
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isEmpty
                        ? "Select $label"
                        : (isTime ? formatTime(value) : value),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (showEditIcon)
              const Icon(Icons.edit, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(ServiceModel service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  service.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
