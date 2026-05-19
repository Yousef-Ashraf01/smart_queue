import 'package:flutter/material.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/tip_card.dart';

class TipsRow extends StatelessWidget {
  const TipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: const Row(
        children: [
          TipCard(icon: Icons.wb_sunny_rounded, label: 'Good lighting'),
          SizedBox(width: 10),
          TipCard(icon: Icons.crop_free_rounded, label: 'Keep ID flat'),
          SizedBox(width: 10),
          TipCard(icon: Icons.hd_rounded, label: 'ID clearly visible'),
        ],
      ),
    );
  }
}
