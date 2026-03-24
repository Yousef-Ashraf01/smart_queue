class RegisterRequestModel {
  final String username;
  final String email;
  final String password;
  final ClientRequestModel client;

  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.client,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "client": client.toJson(),
    };
  }
}

class ClientRequestModel {
  final String nationalId;
  final String phone;
  final String? birthDate;

  ClientRequestModel({
    required this.nationalId,
    required this.phone,
    this.birthDate,
  });

  Map<String, dynamic> toJson() {
    return {"national_id": nationalId, 'phone': phone, "birth_date": birthDate};
  }
}
