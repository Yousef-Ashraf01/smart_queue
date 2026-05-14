import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/core/widgets/dropdown_shimmer.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/service_counter_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/booking_section.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/branch_booking_listener.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_picker_field.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/service_bottom_sheet.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/slots_bottom_sheet.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/timer/presentation/veiw/timer_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

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

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  void _fetchSlotsIfReady() {
    if (selectedService != null && selectedDate != null) {
      context.read<BookingCubit>().getSlots(
        counterId: selectedService!.serviceId,
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

      onBookingSuccess: () {
        _addToCalendar();

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

        _showSuccessDialog(context, hours, minutes, difference, slotStart);
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

                  _BranchInfoHeader(branch: widget.branch),

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
                                return const _EmptyServices();
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
                                child: _ServiceDropdown(
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
      startTime: "${selectedSlot!['start']}:00",
      counterId: selectedService!.serviceId.toString(),
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
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Booking Confirmed 🎉",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your appointment has been successfully booked.\nYou can view it from your bookings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hours > 0
                        ? "⏳ Estimated wait: ${hours}h ${minutes}m"
                        : "⏳ Estimated wait: ${minutes}m",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        TimerScreen.pendingDuration = difference;
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString(
                            'slot_start_time',
                            slotStart.toIso8601String(),
                          );

                          prefs.setString('branchName', widget.branch.name);
                          prefs.setString(
                            'branchAddress',
                            widget.branch.address ?? "",
                          );
                          prefs.setString(
                            'serviceName',
                            selectedService!.serviceName,
                          );
                          prefs.setString(
                            'serviceDesc',
                            selectedService!.serviceDescription,
                          );
                          prefs.setString(
                            'createdAt',
                            DateTime.now().toIso8601String(),
                          );
                        });

                        context.read<ActiveBookingCubit>().setBooking({
                          "branchName": widget.branch.name,
                          "branchAddress": widget.branch.address,
                          "serviceName": selectedService!.serviceName,
                          "serviceDesc": selectedService!.serviceDescription,
                          "slotStart": slotStart.toIso8601String(),
                          "createdAt": DateTime.now().toIso8601String(),
                        });

                        context.pop();
                        context.go(AppRoutes.main);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Go To Home",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _addToCalendar() async {
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
      title: selectedService!.serviceName,
      description: selectedService!.serviceDescription,
      location: widget.branch.address ?? "Branch",
      start: tz.TZDateTime.from(start, tz.local),
      end: tz.TZDateTime.from(end, tz.local),
    );

    event.reminders = [Reminder(minutes: 60), Reminder(minutes: 10)];
    event.eventId = "${selectedService!.serviceId}-${start.toIso8601String()}";

    await _deviceCalendarPlugin.createOrUpdateEvent(event);
  }
}

class _BranchInfoHeader extends StatelessWidget {
  final BranchModel branch;

  const _BranchInfoHeader({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(branch.name, style: AppStyle.bold24black),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(branch.address ?? "No address"),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap:
              () => launchUrl(
                Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=${branch.lat},${branch.lng}",
                ),
              ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, size: 18, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "View on Map",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(branch.phone ?? "", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _EmptyServices extends StatelessWidget {
  const _EmptyServices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text("No Services yet", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ServiceDropdown extends StatelessWidget {
  final ServiceCounterModel? selectedService;

  const _ServiceDropdown({this.selectedService});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.whiteColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedService?.serviceName ?? "Select a service",
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),
          const Icon(Icons.keyboard_arrow_down_sharp),
        ],
      ),
    );
  }
}

class _ServiceBottomSheet extends StatelessWidget {
  final List<ServiceCounterModel> items;
  final ServiceCounterModel? selectedService;
  final void Function(ServiceCounterModel) onSelect;

  const _ServiceBottomSheet({
    required this.items,
    required this.selectedService,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Select Service",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedService?.serviceId == item.serviceId;

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    onSelect(item);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.blue.withOpacity(0.08)
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.serviceDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${item.servicePrice}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Icon(
                              Icons.circle,
                              size: 10,
                              color:
                                  item.isOperational
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
