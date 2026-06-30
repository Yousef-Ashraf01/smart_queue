import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'align_id_inside_frame'.tr(),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
        fontFamily: 'Inter Tight',
      ),
    );
  }
}
