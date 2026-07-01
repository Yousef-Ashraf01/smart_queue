import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class ImageSourceSheet {
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(ImageSource) onPickImage,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ImageSourceSheetContent(onPickImage: onPickImage),
    );
  }
}

class _ImageSourceSheetContent extends StatelessWidget {
  final Future<void> Function(ImageSource) onPickImage;

  const _ImageSourceSheetContent({required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;
    final titleColor = isDark ? Colors.green[300]! : AppColors.teal;

    return Container(
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? ext.cardBorder : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'choose_photo_source'.tr(),
            style: TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'select_photo_source_desc'.tr(),
            style: TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontSize: 13,
              color: ext.subtleText,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _SourceOption(
                  icon: Icons.photo_library_outlined,
                  label: 'gallery'.tr(),
                  subtitle: 'gallery_desc'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await onPickImage(ImageSource.gallery);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'camera'.tr(),
                  subtitle: 'camera_desc'.tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await onPickImage(ImageSource.camera);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: ext.cardBorder),
                ),
              ),
              child: Text(
                'cancel'.tr(),
                style: TextStyle(
                  fontFamily: AppStyle.fontFamily,
                  color: ext.subtleText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;

    final cardBgColor = isDark
        ? Colors.green[900]!.withOpacity(0.1)
        : AppColors.teal.withOpacity(0.04);

    final cardBorderColor = isDark
        ? Colors.green[800]!.withOpacity(0.4)
        : AppColors.tealLight.withOpacity(0.5);

    final gradientColors = isDark
        ? [Colors.green[300]!, Colors.green[800]!]
        : const [AppColors.tealLight, AppColors.teal];

    final textColor = isDark ? Colors.green[300]! : AppColors.teal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cardBorderColor,
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppStyle.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: AppStyle.fontFamily,
                fontSize: 11,
                color: ext.subtleText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
