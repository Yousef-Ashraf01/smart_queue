import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';

class SlotPickerField extends StatelessWidget {
  final Map<String, String>? selectedSlot;
  final VoidCallback onTap;

  const SlotPickerField({
    super.key,
    required this.selectedSlot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
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
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
    );
  }
}
