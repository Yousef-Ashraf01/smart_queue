import 'package:flutter/material.dart';
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
        SectionLabel(text: "Address"),
        const SizedBox(height: 12),
        ReadOnlyInfoCard(
          items: [
            InfoItem(
              icon: Icons.location_on_outlined,
              label: "Area",
              value: address.address,
            ),
            // InfoItem(
            //   icon: Icons.location_city_outlined,
            //   label: "City",
            //   value: address.city,
            // ),
            // InfoItem(
            //   icon: Icons.flag_outlined,
            //   label: "Country",
            //   value: address.country,
            // ),
          ],
        ),
      ],
    );
  }
}
