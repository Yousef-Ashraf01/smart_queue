import 'package:dio/dio.dart';

import 'register_request_model.dart';

extension RegisterRequestFormData on RegisterRequestModel {
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "username": username,
      "email": email,
      "password": password,
      "client.national_id": client.nationalId,
      "client.birth_date": client.birthDate,
      "client.phone": client.phone,
      "client.profession": client.profession,
      "client.gender": client.gender,
      "client.address.address": client.address?.address,
      "client.address.city": client.address?.city,
      "client.address.country": client.address?.country,
      if (client.imageFile != null)
        "client.image": await MultipartFile.fromFile(
          client.imageFile!.path,
          filename: client.imageFile!.name,
        ),
    });
  }
}
