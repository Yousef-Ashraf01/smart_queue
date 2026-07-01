import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/image_source_sheet.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final String? localImagePath;
  final XFile? pickedImage;
  final Future<void> Function(ImageSource) onCameraTap;

  const ProfileAvatarSection({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
    this.localImagePath,
    this.pickedImage,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: ext.cardBorder.withOpacity(0.35),
                child: ClipOval(child: _buildImage()),
              ),
            ),
            GestureDetector(
              onTap:
                  () =>
                      ImageSourceSheet.show(context, onPickImage: onCameraTap),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ext.cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        context.isDark ? 0.28 : 0.1,
                      ),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: AppStyle.userName.adaptive(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            color: ext.subtleText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (pickedImage != null) {
      return Image.file(
        File(pickedImage!.path),
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const SizedBox(
              width: 110,
              height: 110,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF00BFA6),
                ),
              ),
            ),
        errorWidget: (context, url, error) => _fallbackImage(),
      );
    }

    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      localImagePath ?? AppAssets.userAvatar,
      width: 110,
      height: 110,
      fit: BoxFit.cover,
    );
  }
}
