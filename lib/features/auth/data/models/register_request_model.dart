import 'package:camera/camera.dart';

class RegisterRequestModel {
  final String username;
  final String email;
  final String password;
  final ClientRequestModel client;
  final String? verificationToken;

  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
    required this.client,
    this.verificationToken,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      verificationToken: json['verification_token'],
      client: ClientRequestModel.fromJson(json['client'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "client": client.toJson(),
      "verification_token": verificationToken,
    };
  }
}

class ClientRequestModel {
  final String nationalId;
  final String? birthDate;
  final String? profession;
  final String? gender;
  final Address? address;
  final XFile? imageFile;
  final String? imageUrl;
  final String? phone;

  ClientRequestModel({
    required this.nationalId,
    this.address,
    this.imageFile,
    this.imageUrl,
    this.birthDate,
    this.gender,
    this.profession,
    this.phone,
  });

  factory ClientRequestModel.fromJson(Map<String, dynamic> json) {
    return ClientRequestModel(
      nationalId: json['national_id'] ?? '',
      birthDate: json['birth_date'],
      profession: json['profession'],
      gender: json['gender'],
      phone: json['phone'],
      imageUrl: json['image'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "national_id": nationalId,
      "birth_date": birthDate,
      "profession": profession,
      "gender": gender,
      "phone": phone,
      "address": address?.toJson(),
    };
  }
}

class Address {
  final String address;
  final String city;
  final String country;

  Address({required this.address, required this.city, required this.country});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'city': city, 'country': country};
  }
}
