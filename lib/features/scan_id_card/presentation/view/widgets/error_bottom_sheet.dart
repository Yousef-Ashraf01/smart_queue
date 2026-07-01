import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/tip_row.dart';

class ErrorBottomSheet extends StatelessWidget {
  final String message;

  const ErrorBottomSheet({super.key, required this.message});

  static void show(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => ErrorBottomSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;

    final shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.12);
    final errorCircleBg = isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50;
    final errorIconColor = isDark ? Colors.red[300]! : Colors.red.shade400;
    final titleColor = Theme.of(context).colorScheme.onSurface;

    final tipsBoxBg = isDark
        ? Colors.green[900]!.withOpacity(0.15)
        : const Color.fromARGB(255, 118, 226, 136).withOpacity(0.1);
    final tipsBoxBorder = isDark
        ? Colors.green[800]!.withOpacity(0.4)
        : const Color.fromARGB(255, 118, 226, 136).withOpacity(0.3);

    final gradientColors = isDark
        ? [Colors.green[300]!, Colors.green[700]!]
        : const [
            Color.fromARGB(255, 118, 226, 136),
            Color.fromARGB(255, 11, 58, 30),
          ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: errorCircleBg,
            ),
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 30,
              color: errorIconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'could_not_read_id'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: ext.subtleText,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: tipsBoxBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: tipsBoxBorder,
              ),
            ),
            child: Column(
              children: [
                TipRow(
                  icon: Icons.wb_sunny_rounded,
                  text: 'enough_lighting_tip'.tr(),
                ),
                const SizedBox(height: 8),
                TipRow(
                  icon: Icons.crop_free_rounded,
                  text: 'id_inside_frame_tip'.tr(),
                ),
                const SizedBox(height: 8),
                TipRow(
                  icon: Icons.blur_off_rounded,
                  text: 'hold_steady_tip'.tr(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  'try_again'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
