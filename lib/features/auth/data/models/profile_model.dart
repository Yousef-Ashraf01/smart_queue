import 'package:smart_queue/features/auth/data/models/register_request_model.dart';

class ProfileModel {
  final int? id;
  final String username;
  final String email;
  final ClientRequestModel client;

  ProfileModel({
    this.id,
    required this.username,
    required this.email,
    required this.client,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      username: json['username'],
      email: json['email'],
      client: ClientRequestModel.fromJson(json['client']),
    );
  }
}
