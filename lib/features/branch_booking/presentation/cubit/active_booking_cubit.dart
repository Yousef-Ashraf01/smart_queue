import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveBookingCubit extends Cubit<Map<String, dynamic>?> {
  ActiveBookingCubit() : super(null) {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final slotStart = prefs.getString('slot_start_time');

    if (slotStart != null) {
      emit({
        "branchName": prefs.getString('branchName'),
        "branchAddress": prefs.getString('branchAddress'),
        "serviceName": prefs.getString('serviceName'),
        "serviceDesc": prefs.getString('serviceDesc'),
        "slotStart": slotStart,
        "createdAt": prefs.getString('createdAt'),
      });
    }
  }

  void setBooking(Map<String, dynamic> data) {
    emit(data);
  }

  void clearBooking() {
    emit(null);
  }
}
