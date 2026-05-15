import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class BranchRemoteDataSource {
  final Dio dio;

  BranchRemoteDataSource(this.dio);

  Future<List<BranchModel>> getBranches(int orgId) async {
    final response = await dio.get(ApiEndpoints.branches(orgId));

    final Map<String, dynamic> responseData =
        response.data as Map<String, dynamic>;

    final List data = responseData['results'];

    return data.map((e) => BranchModel.fromJson(e)).toList();
  }
}
