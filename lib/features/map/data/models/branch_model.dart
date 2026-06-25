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

  bool get isCurrentlyOpen {
    if (isActive == false) return false;
    if (operatingHours.isEmpty) return isActive ?? false;

    final now = DateTime.now();
    final isoWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    final backendWeekday = isoWeekday - 1; // 0 = Monday, 6 = Sunday (Django backend)
    OperatingHour? todayHour;

    for (final hour in operatingHours) {
      if (hour.weekday == backendWeekday) {
        todayHour = hour;
        break;
      }
    }

    if (todayHour == null) {
      // If operating hours are defined but none match today, the branch is closed today
      return false;
    }

    try {
      final fromParts = todayHour.fromHour.split(':');
      final toParts = todayHour.toHour.split(':');

      final fromMin = int.parse(fromParts[0]) * 60 + int.parse(fromParts[1]);
      final toMin = int.parse(toParts[0]) * 60 + int.parse(toParts[1]);

      final currentMin = now.hour * 60 + now.minute;

      if (toMin < fromMin) {
        // Overnight shift
        return currentMin >= fromMin || currentMin <= toMin;
      }

      return currentMin >= fromMin && currentMin <= toMin;
    } catch (_) {
      return isActive ?? false;
    }
  }
}

