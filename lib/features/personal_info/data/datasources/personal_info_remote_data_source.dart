import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/profile_settings/data/models/profile_model_extension.dart';

class PersonalInfoRemoteDataSource {
  final Dio dio;

  PersonalInfoRemoteDataSource(this.dio);

  Future<ProfileModel> getProfile() async {
    final response = await dio.get(ApiEndpoints.getProfileData);
    print(response.data);
    print(response.data.runtimeType);

    final List data = response.data;

    return ProfileModel.fromJson(data.first);
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final response = await dio.put(
      "${ApiEndpoints.getProfileData}/${profile.id}/",
      data: await profile.toFormData(),
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;

    return ProfileModel(
      id: profile.id,
      username: data['username'],
      email: data['email'],
      client: ClientRequestModel.fromJson({
        "national_id": profile.client.nationalId,
        ...data['client'],
      }),
    );
  }
}
