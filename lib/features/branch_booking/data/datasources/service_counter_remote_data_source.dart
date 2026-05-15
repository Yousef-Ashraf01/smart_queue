import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';

class ServiceCounterRemoteDataSource {
  final Dio dio;

  ServiceCounterRemoteDataSource(this.dio);

  Future<List<ServiceCounterModel>> getServiceCounters(int branchId) async {
    final response = await dio.get(ApiEndpoints.serviceCounters(branchId));

    final Map<String, dynamic> data = response.data as Map<String, dynamic>;

    final List results = data['results'];

    return results.map((e) => ServiceCounterModel.fromJson(e)).toList();
  }
}
