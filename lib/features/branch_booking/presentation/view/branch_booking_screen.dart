import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/core/widgets/dropdown_shimmer.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/service_counter_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/booking_section.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/branch_booking_listener.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/branch_info_header.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_picker_field.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/empty_services.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/service_bottom_sheet.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/service_dropdown.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/slots_bottom_sheet.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/success_dialog.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BranchBookingScreen extends StatefulWidget {
  final BranchModel branch;

  const BranchBookingScreen({super.key, required this.branch});

  @override
  State<BranchBookingScreen> createState() => _BranchBookingScreenState();
}

class _BranchBookingScreenState extends State<BranchBookingScreen> {
  ServiceCounterModel? selectedService;
  DateTime? selectedDate;
  Map<String, String>? selectedSlot;
  List _cachedSlots = [];

  String formatTime(String time) {
    final parts = time.split(':');
    final hour = parts[0].padLeft(2, '0');
    final minute = parts[1].padLeft(2, '0');
    return "$hour:$minute:00";
  }

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  void _fetchSlotsIfReady() {
    if (selectedService != null && selectedDate != null) {
      context.read<BookingCubit>().getSlots(
        counterId: selectedService!.id,
        date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    context.read<ServiceCounterCubit>().fetchServiceCounters(widget.branch.id!);
  }

  @override
  Widget build(BuildContext context) {
    return BranchBookingListener(
      onSlotsLoaded: (slots) {
        _cachedSlots = slots;
      },

      onSlotsError: () {
        setState(() {
          _cachedSlots = [];
          selectedSlot = null;
        });
      },

      onBookingSuccess: (appointment) {
        _addToCalendar(appointment);

        final startParts = selectedSlot!['start']!.split(':');

        final slotStart = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          int.parse(startParts[0]),
          int.parse(startParts[1]),
        );

        final difference = slotStart.difference(DateTime.now());
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;

        // Resolve organization name from branch organizationId
        final orgName = (widget.branch.organizationId == 1)
            ? 'Egyptian Post'
            : (widget.branch.organizationId == 2
                ? 'Traffic Department'
                : widget.branch.name);

        // Build the booking map and add it to the active bookings list
        final bookingData = <String, dynamic>{
          'id': appointment.id,
          'counterId': appointment.counter.id,
          BookingKeys.branchName: widget.branch.name,
          BookingKeys.branchAddress: widget.branch.address ?? "",
          BookingKeys.serviceName: appointment.counter.service.name,
          BookingKeys.serviceDesc: appointment.counter.service.description,
          BookingKeys.slotStart: slotStart.toIso8601String(),
          BookingKeys.slotStartTime: '${selectedSlot!["start"]}:00',
          BookingKeys.slotEnd: '${selectedSlot!["end"]}:00',
          BookingKeys.bookingDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
          'createdAt': DateTime.now().toIso8601String(),
          'serviceId': selectedService!.serviceId,
          'orgName': orgName,
        };

        context.read<ActiveBookingCubit>().addBooking(bookingData);

        _showSuccessDialog(
          context,
          hours,
          minutes,
          difference,
          slotStart,
          appointment,
        );
      },

      onBookingError: (message) {},

      child: Scaffold(
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

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTopBar(),
                  const SizedBox(height: 10),

                  BranchInfoHeader(branch: widget.branch),

                  const SizedBox(height: 30),

                  BookingSection(
                    title: "Service",
                    child:
                        BlocBuilder<ServiceCounterCubit, ServiceCounterState>(
                          builder: (context, state) {
                            if (state is ServiceCounterLoading) {
                              return const DropdownShimmer();
                            }
                            if (state is ServiceCounterLoaded) {
                              if (state.serviceCounter.isEmpty) {
                                return const EmptyServices();
                              }
                              return GestureDetector(
                                onTap:
                                    () => showServiceBottomSheet(
                                      context: context,
                                      items: state.serviceCounter,
                                      selectedService: selectedService,
                                      onSelect: (item) {
                                        setState(() {
                                          selectedService = item;
                                          selectedSlot = null;
                                        });
                                        _fetchSlotsIfReady();
                                      },
                                    ),
                                child: ServiceDropdown(
                                  selectedService: selectedService,
                                ),
                              );
                            }
                            if (state is ServiceCounterError) {
                              return Text(state.message);
                            }
                            return const Text("No services");
                          },
                        ),
                  ),

                  BookingSection(
                    title: "Date",
                    child: CustomPickerField(
                      hint: "Select a date",
                      icon: Icons.calendar_today,
                      valueText:
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : null,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder:
                              (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xff3CC572),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black87,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xff3CC572),
                                    ),
                                  ),
                                ),
                                child: child!,
                              ),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                            selectedSlot = null;
                          });
                          _fetchSlotsIfReady();
                        }
                      },
                    ),
                  ),

                  BookingSection(
                    title: "Time Slot",
                    child: BlocBuilder<BookingCubit, BookingState>(
                      buildWhen:
                          (prev, curr) =>
                              curr is SlotsLoaded ||
                              curr is SlotsLoading ||
                              curr is SlotsError ||
                              curr is BookingLoading ||
                              curr is BookingError ||
                              curr is BookingSuccess,
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            showSlotsBottomSheet(
                              context: context,
                              slots: _cachedSlots,
                              selectedSlot: selectedSlot,
                              onSelect: (slot) {
                                setState(() {
                                  selectedSlot = slot;
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.whiteColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (state is SlotsLoading)
                                  const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Color(0xff3CC572),
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Text(
                                    selectedSlot != null
                                        ? "${selectedSlot!['start']} - ${selectedSlot!['end']}"
                                        : "Select a time slot",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          selectedSlot != null
                                              ? Colors.black87
                                              : Colors.grey[600],
                                    ),
                                  ),
                                const Icon(Icons.keyboard_arrow_down_sharp),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      if (state is BookingLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff3CC572),
                          ),
                        );
                      }
                      return GradientButton(text: "Book", onTap: _onBookTap);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSlotsBottomSheet({
    required BuildContext context,
    required List slots,
    required Map<String, String>? selectedSlot,
    required Function(Map<String, String>) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => SlotsBottomSheet(
            slots: slots,
            selectedSlot: selectedSlot,
            onSelect: onSelect,
          ),
    );
  }

  void _onBookTap() {
    if (selectedService == null ||
        selectedDate == null ||
        selectedSlot == null) {
      AppFlushbar.show(
        context,
        message: "Please fill all fields!",
        type: MessageType.error,
      );

      return;
    }

    final request = AppointmentModel(
      date: DateFormat('yyyy-MM-dd').format(selectedDate!),
      startTime: formatTime(selectedSlot!['start']!),
      counterId: selectedService!.id.toString(),
      wantReminder: true,
      additionalInfo: "",
      paid: false,
      amountToPay: selectedService!.servicePrice,
    );

    context.read<BookingCubit>().bookAppointment(appointment: request);
  }

  void showServiceBottomSheet({
    required BuildContext context,
    required List<ServiceCounterModel> items,
    required ServiceCounterModel? selectedService,
    required Function(ServiceCounterModel) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ServiceBottomSheet(
            items: items,
            selectedService: selectedService,
            onSelect: onSelect,
          ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    int hours,
    int minutes,
    Duration difference,
    DateTime slotStart,
    AppointmentResponseModel appointment,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => BookingSuccessDialog(
            hours: hours,
            minutes: minutes,
            difference: difference,
            slotStart: slotStart,
            appointment: appointment,
            branch: widget.branch,
            selectedService: selectedService!,
            selectedSlot: selectedSlot!,
          ),
    );
  }

  Future<void> _addToCalendar(AppointmentResponseModel appointment) async {
    if (selectedService == null || selectedDate == null || selectedSlot == null)
      return;

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

    final startParts = selectedSlot!['start']!.split(':');
    final endParts = selectedSlot!['end']!.split(':');

    final start = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    final end = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    final event = Event(
      calendars.first.id,
      title: appointment.counter.service.name,
      description: appointment.counter.service.description,
      location: widget.branch.address ?? "Branch",
      start: tz.TZDateTime.from(start, tz.local),
      end: tz.TZDateTime.from(end, tz.local),
    );

    event.reminders = [Reminder(minutes: 60), Reminder(minutes: 10)];
    event.eventId = "${selectedService!.serviceId}-${start.toIso8601String()}";

    await _deviceCalendarPlugin.createOrUpdateEvent(event);
  }
}
