import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/utils/snackbar_helper.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/core/widgets/dropdown_shimmer.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_request_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/services_cubit.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/booking_section.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_drop_down.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_picker_field.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';

class BranchBookingScreen extends StatefulWidget {
  final GovernmentBranch branch;

  const BranchBookingScreen({super.key, required this.branch});

  @override
  State<BranchBookingScreen> createState() => _BranchBookingScreenState();
}

class _BranchBookingScreenState extends State<BranchBookingScreen> {
  ServiceModel? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<PersonalInfoCubit>().state;

    String phone = "";

    if (profileState is PersonalInfoLoaded) {
      phone = profileState.profile.client.phone ?? "";
    }

    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          _showSuccessDialog(context);
        }

        if (state is BookingError) {
          SnackbarHelper.showSnackbar(
            context: context,
            title: "Error",
            message: state.message,
            type: "error",
          );
        }
      },
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
                  Text(
                    widget.branch.name,
                    style: AppStyle.bold24black,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  BookingSection(
                    title: "Service",
                    child: BlocBuilder<ServicesCubit, ServicesState>(
                      builder: (context, state) {
                        if (state is ServicesLoading) {
                          return const DropdownShimmer();
                        }

                        if (state is ServicesLoaded) {
                          return CustomDropdown(
                            hint: "Select a service",
                            value: selectedService?.name,
                            items: state.services.map((e) => e.name).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedService = state.services.firstWhere(
                                  (e) => e.name == value,
                                );
                              });
                            },
                          );
                        } else if (state is ServicesError) {
                          return Text(state.message);
                        }

                        return const Text("Failed to load services");
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
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) {
                            return Theme(
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
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                    ),
                  ),
                  BookingSection(
                    title: "Time",
                    child: CustomPickerField(
                      hint: "Select a time",
                      icon: Icons.access_time,
                      valueText: selectedTime?.format(context),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  dayPeriodTextColor: Colors.black87,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          setState(() => selectedTime = pickedTime);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 260),
                  BlocBuilder<BookingCubit, BookingState>(
                    builder: (context, state) {
                      if (state is BookingLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.green[200],
                          ),
                        );
                      }
                      return GradientButton(
                        text: "Book",
                        onTap: () {
                          if (selectedService == null ||
                              selectedDate == null ||
                              selectedTime == null) {
                            SnackbarHelper.showSnackbar(
                              context: context,
                              title: "Error",
                              message: "Please fill all fields!",
                              type: "error",
                            );
                            return;
                          }

                          final cubit = context.read<BookingCubit>();

                          final start = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          final end = start.add(selectedService!.duration);

                          final startTime = DateFormat(
                            "HH:mm:ss",
                          ).format(start);
                          final endTime = DateFormat("HH:mm:ss").format(end);

                          final request = AppointmentRequestModel(
                            date: DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedDate!),
                            startTime: startTime,
                            endTime: endTime,
                            service: selectedService!.id,
                            paymentType: "full",
                            rescheduleAttempts: 0,
                          );

                          final appointment = AppointmentModel(
                            appointmentRequest: 0,
                            phone: phone,
                            address: "Cairo",
                            wantReminder: true,
                            additionalInfo: "",
                            paid: false,
                            amountToPay: selectedService!.price.toDouble(),
                          );

                          cubit.bookAppointment(
                            request: request,
                            appointment: appointment,
                          );
                        },
                      );
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

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
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
                // ✅ Circle Icon
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.green, size: 40),
                ),

                const SizedBox(height: 20),

                // ✅ Title
                const Text(
                  "Booking Confirmed 🎉",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // ✅ Subtitle
                const Text(
                  "Your appointment has been successfully booked.\nYou can view it from your bookings.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 25),

                // ✅ Buttons Row
                Row(
                  children: [
                    // // Back Button
                    // Expanded(
                    //   child: OutlinedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //     style: OutlinedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 12),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       "Stay",
                    //       style: TextStyle(color: Colors.green[200]),
                    //     ),
                    //   ),
                    // ),
                    //
                    // const SizedBox(width: 10),

                    // Go Home Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

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
              ],
            ),
          ),
        );
      },
    );
  }
}
