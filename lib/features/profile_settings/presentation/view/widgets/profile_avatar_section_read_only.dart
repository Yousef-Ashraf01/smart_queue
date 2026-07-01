import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class ProfileAvatarSectionReadOnly extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final String? localImagePath;
  final XFile? pickedImage;

  const ProfileAvatarSectionReadOnly({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
    this.localImagePath,
    this.pickedImage,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Column(
      children: [
        // Premium Double-Ring Avatar
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF10B981), // Emerald
                Color(0xFF3B82F6), // Blue
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ext.cardColor,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: ext.cardBorder.withOpacity(0.3),
              child: ClipOval(child: _buildImage()),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Profile details cards
        Text(
          name,
          style: AppStyle.userName
              .copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              )
              .adaptive(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(
            color: ext.subtleText,
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
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
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF10B981),
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
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}
