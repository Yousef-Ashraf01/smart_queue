import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/operations_history/data/models/paginated_response.dart';

class BookingRemoteDataSource {
  final Dio dio;

  BookingRemoteDataSource(this.dio);

  Future<AppointmentResponseModel> createAppointment(
    AppointmentModel appointment,
  ) async {
    final response = await dio.post(
      ApiEndpoints.appointments,
      data: appointment.toJson(),
    );
    return AppointmentResponseModel.fromJson(response.data);
  }

  Future<List<ServiceModel>> getServices() async {
    final response = await dio.get(ApiEndpoints.services);

    final List data = response.data['results'];

    return data.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<PaginatedResponse<AppointmentResponseModel>> getOperations(
    String? url,
  ) async {
    final response = await dio.get(url ?? ApiEndpoints.appointments);
    final List data = response.data['results'];

    return PaginatedResponse(
      items: data.map((e) => AppointmentResponseModel.fromJson(e)).toList(),
      hasMore: response.data['next'] != null,
      nextUrl: response.data['next'],
    );
  }

  Future<AppointmentResponseModel> getRequestById(int id) async {
    final response = await dio.get('${ApiEndpoints.appointments}$id/');

    return AppointmentResponseModel.fromJson(response.data);
  }

  Future<void> deleteAppointmentRequest(int id) async {
    await dio.delete('${ApiEndpoints.appointments}$id/');
  }

  Future<void> updateAppointmentRequest(
    int id,
    AppointmentResponseModel model,
  ) async {
    await dio.put('${ApiEndpoints.appointments}$id/', data: model.toJson());
  }

  Future<List<dynamic>> getAvailableSlots({
    required int counterId,
    required String date,
  }) async {
    final response = await dio.get(
      ApiEndpoints.availableSlots(counterId),
      queryParameters: {'date': date},
    );

    return response.data['slots'];
  }

  Future<void> cancelAppointment(int id) async {
    await dio.patch(
      '${ApiEndpoints.appointments}$id/',
      data: {"canceled": true},
    );
  }
}
