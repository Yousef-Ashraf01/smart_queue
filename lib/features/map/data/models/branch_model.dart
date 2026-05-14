class OperatingHour {
  final int id;
  final int weekday;
  final String fromHour;
  final String toHour;

  OperatingHour({
    required this.id,
    required this.weekday,
    required this.fromHour,
    required this.toHour,
  });

  factory OperatingHour.fromJson(Map<String, dynamic> json) {
    return OperatingHour(
      id: json['id'],
      weekday: json['weekday'],
      fromHour: json['from_hour'],
      toHour: json['to_hour'],
    );
  }
}

class BranchModel {
  final int? id;
  final int? organizationId;
  final String name;
  final String? email;
  final String? phone;
  final bool? isActive;
  final double? lat;
  final double? lng;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final double? distanceInKm;
  final List<OperatingHour> operatingHours;

  BranchModel({
    this.id,
    this.organizationId,
    required this.name,
    this.email,
    this.phone,
    this.isActive,
    this.lat,
    this.lng,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.distanceInKm,
    this.operatingHours = const [],
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final addressJson = json['address'];

    return BranchModel(
      id: json['id'],
      organizationId: json['organization'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      isActive: json['is_active'],
      lat:
          addressJson != null
              ? (addressJson['latitude'] as num?)?.toDouble()
              : null,
      lng:
          addressJson != null
              ? (addressJson['longitude'] as num?)?.toDouble()
              : null,
      address: addressJson != null ? addressJson['address'] : null,
      city: addressJson != null ? addressJson['city'] : null,
      country: addressJson != null ? addressJson['country'] : null,
      postalCode: addressJson != null ? addressJson['postal_code'] : null,
      operatingHours:
          (json['operating_hours'] as List? ?? [])
              .map((e) => OperatingHour.fromJson(e))
              .toList(),
    );
  }
}
