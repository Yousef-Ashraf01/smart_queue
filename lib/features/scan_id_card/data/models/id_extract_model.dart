class IdExtractModel {
  final String nationalId;
  final String nameArabic;
  final String address;

  IdExtractModel({
    required this.nationalId,
    required this.nameArabic,
    required this.address,
  });

  factory IdExtractModel.fromJson(Map<String, dynamic> json) {
    return IdExtractModel(
      nationalId: json['national_id'],
      nameArabic: json['name_arabic'],
      address: json['address'],
    );
  }
}
