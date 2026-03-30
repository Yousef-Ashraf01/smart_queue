class OrganizationModel {
  final int id;
  final String name;
  final String code;
  final String? brief;
  final String? image;
  final String email;
  final String website;
  final bool isActive;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.code,
    this.brief,
    this.image,
    required this.email,
    required this.website,
    required this.isActive,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      brief: json['brief'],
      image: json['image'],
      email: json['email'],
      website: json['website'],
      isActive: json['is_active'],
    );
  }
}
