class AuthTokenModel {
  final String access;
  final String refresh;

  AuthTokenModel({required this.access, required this.refresh});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(access: json['access'], refresh: json['refresh']);
  }
}
