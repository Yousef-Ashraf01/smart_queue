import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(BookingInitial());

  Future<void> bookAppointment({required AppointmentModel appointment}) async {
    emit(BookingLoading());

    final result = await repository.createAppointment(appointment);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (appointment) => emit(BookingSuccess(appointment)),
    );
  }

  Future<void> getSlots({required int counterId, required String date}) async {
    emit(SlotsLoading());

    final result = await repository.getAvailableSlots(
      counterId: counterId,
      date: date,
    );

    result.fold(
      (failure) => emit(SlotsError(failure.message)),
      (slots) => emit(SlotsLoaded(slots)),
    );
  }

  Future<void> initiatePayment(AppointmentResponseModel appointment) async {
    emit(PaymentIntentLoading());

    final result = await repository.createPaymentIntent(appointment.id);

    result.fold(
      (failure) => emit(PaymentIntentError(failure.message)),
      (paymentIntent) => emit(
        PaymentIntentSuccess(
          clientSecret: paymentIntent.clientSecret,
          appointment: appointment,
        ),
      ),
    );
  }

  Future<void> confirmStripePayment(
    String clientSecret,
    AppointmentResponseModel appointment,
  ) async {
    try {
      debugPrint("CLIENT SECRET = $clientSecret");

      debugPrint("STEP 1: initPaymentSheet");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Smart Queue',
          primaryButtonLabel:
              'Pay  •  ${appointment.counter.service.price.toStringAsFixed(0)} EGP',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            shapes: PaymentSheetShape(
              borderRadius: 16,
              borderWidth: 1,
              shadow: PaymentSheetShadowParams(color: Colors.black12),
            ),
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF008080),
              icon: const Color(0xFF008080),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: const Color(0xFF008080),
                  text: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      debugPrint("STEP 2: initPaymentSheet SUCCESS");

      debugPrint("STEP 3: presentPaymentSheet");

      await Stripe.instance.presentPaymentSheet();

      debugPrint("STEP 4: PAYMENT SUCCESS");

      emit(PaymentCompleted(appointment));
    } on StripeException catch (e) {
      debugPrint("STRIPE EXCEPTION");
      debugPrint("CODE = ${e.error.code}");
      debugPrint("MESSAGE = ${e.error.localizedMessage}");
      debugPrint("ERROR = ${e.error}");

      if (e.error.code == FailureCode.Canceled) {
        emit(PaymentCancelled());
      } else {
        emit(PaymentIntentError(e.error.localizedMessage ?? 'Payment failed'));
      }
    } catch (e, stackTrace) {
      debugPrint("GENERAL EXCEPTION");
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      emit(PaymentIntentError(e.toString()));
    }
  }
}
