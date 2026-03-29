import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/home/data/models/organization_model.dart';

class OrganizationRemoteDataSource {
  final Dio dio;

  OrganizationRemoteDataSource(this.dio);

  Future<List<OrganizationModel>> getOrganizations() async {
    final response = await dio.get(ApiEndpoints.organizations);

    final List data = response.data['results'];

    return data.map((e) => OrganizationModel.fromJson(e)).toList();
  }
}
