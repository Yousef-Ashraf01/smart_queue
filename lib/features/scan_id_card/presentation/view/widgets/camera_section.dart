import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/camera_place_holder.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/camera_preview.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/capture_status.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/grid_overlay.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/id_frame_painter.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/scan_line.dart';

class CameraSection extends StatelessWidget {
  final bool isCameraReady;
  final CameraController? controller;
  final Animation<double> scanAnim;
  final File? capturedImage;
  final GlobalKey frameKey;
  final GlobalKey cameraKey;

  const CameraSection({
    super.key,
    required this.isCameraReady,
    required this.controller,
    required this.scanAnim,
    required this.capturedImage,
    required this.frameKey,
    required this.cameraKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: cameraKey,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            isCameraReady && controller != null
                ? CameraPreviewWidget(controller: controller!)
                : const CameraPlaceholder(),
            const IgnorePointer(child: GridOverlay()),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),
            ScanLine(scanAnim: scanAnim),
            Center(child: IdFrame(key: frameKey)),
            CaptureStatus(capturedImage: capturedImage),
          ],
        ),
      ),
    );
  }
}
