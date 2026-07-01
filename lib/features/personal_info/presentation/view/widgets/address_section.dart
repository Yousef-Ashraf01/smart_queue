import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/read_only_info_card.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/section_label.dart';

class AddressSection extends StatelessWidget {
  final Address address;

  const AddressSection({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: "address_label".tr()),
        const SizedBox(height: 12),
        ReadOnlyInfoCard(
          items: [
            InfoItem(
              icon: Icons.location_on_outlined,
              label: "area_label".tr(),
              value: address.address,
            ),
          ],
        ),
      ],
    );
  }
}
