import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/tip_card.dart';

class TipsRow extends StatelessWidget {
  const TipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          TipCard(icon: Icons.wb_sunny_rounded, label: 'good_lighting'.tr()),
          const SizedBox(width: 10),
          TipCard(icon: Icons.crop_free_rounded, label: 'keep_id_flat'.tr()),
          const SizedBox(width: 10),
          TipCard(icon: Icons.hd_rounded, label: 'id_clearly_visible'.tr()),
        ],
      ),
    );
  }
}
