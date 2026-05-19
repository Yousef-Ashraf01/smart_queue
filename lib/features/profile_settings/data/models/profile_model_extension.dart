import 'package:dio/dio.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';

extension ProfileModelFormData on ProfileModel {
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "username": username,
      "email": email,
      "password": "string",
      "client.national_id": client.nationalId,
      "client.birth_date": client.birthDate,
      "client.phone": client.phone,
      "client.profession": client.profession,
      "client.gender": client.gender,
      if (client.imageFile != null)
        "client.image": await MultipartFile.fromFile(
          client.imageFile!.path,
          filename: client.imageFile!.name,
        ),
    });
  }
}
