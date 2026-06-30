import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/read_only_field.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/section_label.dart';

class PersonalInfoSection extends StatelessWidget {
  final String nationalId;
  final String day;
  final String month;
  final String year;

  const PersonalInfoSection({
    super.key,
    required this.nationalId,
    required this.day,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: "personal_info".tr()),
        const SizedBox(height: 12),
        ReadOnlyField(
          label: "national_id_label".tr(),
          value: nationalId,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 12),
        ReadOnlyField(
          label: "birth_date_label".tr(),
          value: day.isEmpty ? '' : '$day / $month / $year',
          icon: Icons.cake_outlined,
        ),
      ],
    );
  }
}
