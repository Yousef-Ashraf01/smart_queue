import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/core/services/notification_service.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'active_booking_state.dart';

class ActiveBookingCubit extends Cubit<ActiveBookingState> {
  final BookingRepository repository;

  ActiveBookingCubit(this.repository) : super(ActiveBookingInitial()) {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    emit(ActiveBookingLoading());
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('active_bookings_list') ?? [];

    if (list.isEmpty) {
      // Check legacy single-booking keys and migrate them if present
      final slotStart = prefs.getString(BookingKeys.slotStartOnly);
      final slotEnd = prefs.getString(BookingKeys.slotEnd);
      final bookingDate = prefs.getString(BookingKeys.bookingDate);
      final appointmentId = prefs.getInt(BookingKeys.appointmentId);
      final counterId = prefs.getInt(BookingKeys.counterId);

      if (slotStart != null &&
          appointmentId != null &&
          counterId != null &&
          slotEnd != null &&
          bookingDate != null) {
        final serviceId = prefs.getInt(BookingKeys.serviceId);
        final cancelledServiceIds =
            prefs.getStringList(BookingKeys.cancelledServiceIds) ?? [];
        final canCancel =
            serviceId == null ||
            !cancelledServiceIds.contains(serviceId.toString());

        final legacyBooking = {
          "id": appointmentId,
          "counterId": counterId,
          "branchName": prefs.getString(BookingKeys.branchName) ?? "",
          "branchAddress": prefs.getString(BookingKeys.branchAddress) ?? "",
          "serviceName": prefs.getString(BookingKeys.serviceName) ?? "",
          "serviceDesc": prefs.getString(BookingKeys.serviceDesc) ?? "",
          BookingKeys.slotStart: () {
            final date = prefs.getString(BookingKeys.bookingDate) ?? "";
            final time = prefs.getString(BookingKeys.slotStartOnly) ?? "";
            if (date.isNotEmpty && time.isNotEmpty) {
              return "${date}T${time}";
            }
            return "";
          }(),
          BookingKeys.slotEnd: prefs.getString(BookingKeys.slotEnd) ?? "",
          "createdAt": prefs.getString(BookingKeys.createdAt) ?? "",
          BookingKeys.slotStartTime:
              prefs.getString(BookingKeys.slotStartOnly) ?? "",
          BookingKeys.bookingDate:
              prefs.getString(BookingKeys.bookingDate) ?? "",
          "serviceId": serviceId,
          "canCancel": canCancel,
          "orgName": "Egyptian Post",
        };
        list.add(jsonEncode(legacyBooking));
        await prefs.setStringList('active_bookings_list', list);

        // clean legacy individual keys to avoid repeated migration
        await prefs.remove(BookingKeys.appointmentId);
        await prefs.remove(BookingKeys.counterId);
        await prefs.remove(BookingKeys.serviceId);
        await prefs.remove(BookingKeys.slotStartTime);
        await prefs.remove(BookingKeys.slotStart);
        await prefs.remove(BookingKeys.slotEnd);
        await prefs.remove(BookingKeys.bookingDate);
        await prefs.remove(BookingKeys.branchName);
        await prefs.remove(BookingKeys.branchAddress);
        await prefs.remove(BookingKeys.serviceName);
        await prefs.remove(BookingKeys.serviceDesc);
        await prefs.remove(BookingKeys.createdAt);
        await prefs.remove(BookingKeys.slotStartOnly);
      }
    }

    if (list.isEmpty) {
      emit(ActiveBookingInitial());
      return;
    }

    final cancelledServiceIds =
        prefs.getStringList(BookingKeys.cancelledServiceIds) ?? [];
    final List<Map<String, dynamic>> bookings = [];
    final List<String> validItems = [];

    for (final item in list) {
      try {
        final Map<String, dynamic> booking =
            jsonDecode(item) as Map<String, dynamic>;

        final slotStartRaw = booking[BookingKeys.slotStart] as String?;
        if (slotStartRaw != null) {
          final slotStart = DateTime.tryParse(slotStartRaw);
          if (slotStart != null && slotStart.isBefore(DateTime.now())) {
            continue;
          }

          // Re-schedule / synchronize reminders with the OS on load
          final bookingId = booking['id'] as int?;
          final orgName = booking['orgName'] as String? ?? 'Egyptian Post';
          final serviceName = booking['serviceName'] as String? ?? '';
          if (bookingId != null && slotStart != null) {
            NotificationService.scheduleBookingReminders(
              bookingId: bookingId,
              orgName: orgName,
              serviceName: serviceName,
              slotStart: slotStart,
            );
          }
        }

        final serviceId = booking['serviceId'] as int?;
        booking['canCancel'] =
            serviceId == null ||
            !cancelledServiceIds.contains(serviceId.toString());
        bookings.add(booking);
        validItems.add(item);
      } catch (_) {}
    }

    // If some bookings were expired and removed, persist the cleaned list
    if (validItems.length != list.length) {
      await prefs.setStringList('active_bookings_list', validItems);
    }

    if (bookings.isEmpty) {
      emit(ActiveBookingInitial());
    } else {
      emit(ActiveBookingLoaded(bookings));
    }
  }

  Future<void> addBooking(Map<String, dynamic> booking) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('active_bookings_list') ?? [];

    final serviceId = booking['serviceId'] as int?;
    final cancelledServiceIds =
        prefs.getStringList(BookingKeys.cancelledServiceIds) ?? [];
    final canCancel =
        serviceId == null ||
        !cancelledServiceIds.contains(serviceId.toString());

    final bookingWithCancel = Map<String, dynamic>.from(booking);
    bookingWithCancel['canCancel'] = canCancel;

    // شيل لو موجود عشان تمنع duplicates
    list.removeWhere((item) {
      try {
        final b = jsonDecode(item) as Map;
        return b['id'] == booking['id'];
      } catch (_) {
        return false;
      }
    });

    list.add(jsonEncode(bookingWithCancel));
    await prefs.setStringList('active_bookings_list', list);

    // Schedule local notification reminders
    final slotStartRaw = booking[BookingKeys.slotStart] as String?;
    final bookingId = booking['id'] as int?;
    final orgName = booking['orgName'] as String? ?? 'Egyptian Post';
    final serviceName = booking['serviceName'] as String? ?? '';
    if (slotStartRaw != null && bookingId != null) {
      try {
        final slotStart = DateTime.parse(slotStartRaw);
        NotificationService.scheduleBookingReminders(
          bookingId: bookingId,
          orgName: orgName,
          serviceName: serviceName,
          slotStart: slotStart,
        );
      } catch (_) {}
    }

    // Update state
    final List<Map<String, dynamic>> currentBookings = [];
    final state = this.state;
    if (state is ActiveBookingLoaded) {
      currentBookings.addAll(state.bookings);
    }
    currentBookings.removeWhere((b) => b['id'] == booking['id']);
    currentBookings.add(bookingWithCancel);

    emit(ActiveBookingLoaded(currentBookings));
  }

  Future<void> setBooking(Map<String, dynamic> data) async {
    await addBooking(data);
  }

  Future<void> removeBooking(int id) async {
    // Cancel any scheduled local notification reminders
    await NotificationService.cancelBookingReminders(id);

    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('active_bookings_list') ?? [];

    list.removeWhere((item) {
      try {
        final b = jsonDecode(item) as Map;
        return b['id'] == id;
      } catch (_) {
        return false;
      }
    });
    await prefs.setStringList('active_bookings_list', list);

    final state = this.state;
    if (state is ActiveBookingLoaded) {
      final updatedBookings =
          state.bookings.where((b) => b['id'] != id).toList();
      if (updatedBookings.isEmpty) {
        emit(ActiveBookingInitial());
      } else {
        emit(ActiveBookingLoaded(updatedBookings));
      }
    }
  }

  void clearBooking() {
    emit(ActiveBookingInitial());
  }

  Future<void> cancelBooking(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final appointmentId = id.toString();

    final cancelledIds = prefs.getStringList(BookingKeys.cancelledIds) ?? [];

    if (cancelledIds.contains(appointmentId)) {
      emit(
        ActiveBookingError("You already cancelled this appointment before."),
      );
      return;
    }

    emit(ActiveBookingCancelling());

    final result = await repository.cancelAppointment(id);

    result.fold((failure) => emit(ActiveBookingError(failure.message)), (
      _,
    ) async {
      await NotificationService.cancelBookingReminders(id);

      cancelledIds.add(appointmentId);
      await prefs.setStringList(BookingKeys.cancelledIds, cancelledIds);

      if (serviceId != null) {
        cancelledServiceIds.add(serviceId.toString());
        await prefs.setStringList(
          BookingKeys.cancelledServiceIds,
          cancelledServiceIds,
        );
      }

      final List<String> list =
          prefs.getStringList('active_bookings_list') ?? [];
      list.removeWhere((item) {
        try {
          final b = jsonDecode(item) as Map;
          return b['id'] == id;
        } catch (_) {
          return false;
        }
      });
      await prefs.setStringList('active_bookings_list', list);

      final updatedBookings =
          currentBookings.where((b) => b['id'] != id).toList();

      // ← اعمل emit للـ Cancelled بعد ما تحدد هتعمل ايه
      if (updatedBookings.isEmpty) {
        emit(ActiveBookingCancelled());
        emit(ActiveBookingInitial());
      } else {
        emit(ActiveBookingCancelled());
        emit(ActiveBookingLoaded(updatedBookings));
      }
    });
  }
}
