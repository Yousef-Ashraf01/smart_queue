import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';

import '../../../data/models/appointment_response_model.dart';

class BranchBookingListener extends StatelessWidget {
  final Widget child;

  final Function(List slots) onSlotsLoaded;
  final VoidCallback onSlotsError;
  final Function(AppointmentResponseModel appointment) onBookingSuccess;
  final Function(String message) onBookingError;

  const BranchBookingListener({
    super.key,
    required this.child,
    required this.onSlotsLoaded,
    required this.onSlotsError,
    required this.onBookingSuccess,
    required this.onBookingError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is SlotsLoaded) {
          onSlotsLoaded(state.slots);
        }

        if (state is SlotsError) {
          onSlotsError();

          final message =
              state.message.contains("past date")
                  ? "Cannot select a past date. Please choose a future date."
                  : state.message;

          AppFlushbar.show(context, message: message, type: MessageType.error);
        }

        if (state is BookingSuccess) {
          onBookingSuccess(state.appointment);
        }

        if (state is BookingError) {
          final message =
              state.message.contains("pending appointment")
                  ? "You already have a booking for this service!"
                  : state.message;

          onBookingError(message);

          AppFlushbar.show(context, message: message, type: MessageType.error);
        }
      },
      child: child,
    );
  }
}
