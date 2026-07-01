import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class ImagePickerSection extends StatelessWidget {
  final XFile? pickedImage;
  final VoidCallback onTap;

  const ImagePickerSection({
    super.key,
    required this.pickedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;

    final borderColor = pickedImage != null
        ? (isDark ? Colors.green[400]! : const Color.fromARGB(255, 118, 226, 136))
        : (isDark ? ext.cardBorder : Colors.grey.shade300);

    final shadowColor = isDark
        ? Colors.transparent
        : const Color.fromARGB(255, 11, 58, 30).withOpacity(0.12);

    final innerCircleBg = isDark
        ? Colors.green[900]!.withOpacity(0.25)
        : const Color.fromARGB(255, 118, 226, 136).withOpacity(0.15);

    final innerIconColor = isDark
        ? Colors.green[300]!
        : const Color.fromARGB(255, 11, 58, 30);

    final gradientColors = isDark
        ? [Colors.green[300]!, Colors.green[700]!]
        : const [
            Color.fromARGB(255, 118, 226, 136),
            Color.fromARGB(255, 11, 58, 30),
          ];

    final textColor = pickedImage != null
        ? (isDark ? Colors.green[300]! : const Color.fromARGB(255, 11, 58, 30))
        : (isDark ? ext.subtleText : Colors.grey);

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ext.cardColor,
                    border: Border.all(
                      color: borderColor,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child:
                        pickedImage != null
                            ? Image.file(
                              File(pickedImage!.path),
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: innerCircleBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 26,
                                    color: innerIconColor,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              pickedImage != null
                  ? 'change_photo'.tr()
                  : 'add_profile_photo'.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
