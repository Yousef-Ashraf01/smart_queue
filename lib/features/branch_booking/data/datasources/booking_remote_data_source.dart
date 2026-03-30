import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_request_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/data/models/paginated_response.dart';

class BookingRemoteDataSource {
  final Dio dio;

  BookingRemoteDataSource(this.dio);

  // Step 1: create request
  Future<int> createAppointmentRequest(AppointmentRequestModel request) async {
    final response = await dio.post(
      ApiEndpoints.appointmentRequests,
      data: request.toJson(),
    );

    return response.data['id']; // مهم جدًا
  }

  // Step 2: create appointment
  Future<void> createAppointment(AppointmentModel appointment) async {
    await dio.post(ApiEndpoints.appointments, data: appointment.toJson());
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await dio.get(ApiEndpoints.services);

    final List data = response.data['results'];

    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<PaginatedResponse<AppointmentModel>> getOperations(String? url) async {
    final response = await dio.get(url ?? ApiEndpoints.appointments);

    final List data = response.data['results'];

    return PaginatedResponse(
      items: data.map((e) => AppointmentModel.fromJson(e)).toList(),
      hasMore: response.data['next'] != null,
      nextUrl: response.data['next'],
    );
  }
}
