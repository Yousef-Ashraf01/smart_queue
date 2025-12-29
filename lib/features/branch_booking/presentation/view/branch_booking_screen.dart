import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/utils/snackbar_helper.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/booking_section.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_drop_down.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/custom_picker_field.dart';
import 'package:smart_queue/features/branch_booking/presentation/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/main/main_screen.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';

class BranchBookingScreen extends StatefulWidget {
  final GovernmentBranch branch;

  const BranchBookingScreen({super.key, required this.branch});

  @override
  State<BranchBookingScreen> createState() => _BranchBookingScreenState();
}

class _BranchBookingScreenState extends State<BranchBookingScreen> {
  String? selectedService;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> services = [
    "Passport",
    "Driving License",
    "Postal Service",
  ];

  @override
  Widget build(BuildContext context) {
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
                  child: CustomDropdown(
                    hint: "Select a service",
                    value: selectedService,
                    items: services,
                    onChanged: (v) => setState(() => selectedService = v),
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
                        lastDate: DateTime.now().add(const Duration(days: 365)),
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
                GradientButton(
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
