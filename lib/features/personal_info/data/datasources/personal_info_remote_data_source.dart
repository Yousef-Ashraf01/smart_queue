import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/auth/data/models/client_model.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';

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
      data: {
        "username": profile.username,
        "email": profile.email,
        "password": "string",
        "client": profile.client.toJson(),
      },
    );

    final data = response.data;

    return ProfileModel(
      id: profile.id,
      username: data['username'],
      email: data['email'],
      client: ClientModel.fromJson({
        "national_id": profile.client.nationalId,
        ...data['client'],
      }),
    );
  }
}
