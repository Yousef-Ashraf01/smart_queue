import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/services/notification_service.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/booking_cubit.dart';

import '../../../data/models/appointment_response_model.dart';

class BranchBookingListener extends StatelessWidget {
  final Widget child;

  final Function(List slots) onSlotsLoaded;
  final VoidCallback onSlotsError;
  final Function(AppointmentResponseModel appointment) onBookingSuccess;
  final Function(String message) onBookingError;
  final Function(AppointmentResponseModel appointment)? onPaymentCompleted;

  const BranchBookingListener({
    super.key,
    required this.child,
    required this.onSlotsLoaded,
    required this.onSlotsError,
    required this.onBookingSuccess,
    required this.onBookingError,
    this.onPaymentCompleted,
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
                  ? "cannot_select_past_date_future".tr()
                  : state.message.localizedApi;

          AppFlushbar.show(context, message: message, type: MessageType.error);
        }

        if (state is BookingSuccess) {
          onBookingSuccess(state.appointment);
        }

        if (state is BookingError) {
          String message = state.message.localizedApi;
          if (message.contains("pending appointment")) {
            message = "already_have_booking_service".tr();
          } else if (message.contains("another appointment scheduled")) {
            message = "another_appointment_timeframe".tr();
          }

          onBookingError(message);

          AppFlushbar.show(context, message: message, type: MessageType.error);
        }

        // Payment flow states
        if (state is PaymentIntentSuccess) {
          context.read<BookingCubit>().confirmStripePayment(
            state.clientSecret,
            state.appointment,
          );
        }

        if (state is PaymentCompleted) {
          // Fire payment confirmation notification
          NotificationService.showPaymentSuccessNotification(
            bookingId: state.appointment.id,
            serviceName: state.appointment.counter.service.name,
            amount: state.appointment.counter.service.price,
          );

          if (onPaymentCompleted != null) {
            onPaymentCompleted!(state.appointment);
          }
        }

        if (state is PaymentIntentError) {
          AppFlushbar.show(
            context,
            message: state.message.localizedApi,
            type: MessageType.error,
          );
        }

        if (state is PaymentCancelled) {
          AppFlushbar.show(
            context,
            message: "payment_cancelled_booking_saved".tr(),
            type: MessageType.warning,
          );
        }
      },
      child: child,
    );
  }
}
