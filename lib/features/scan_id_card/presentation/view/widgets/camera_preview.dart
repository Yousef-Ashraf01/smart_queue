import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;

  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewRatio = controller.value.aspectRatio;
        final containerRatio = constraints.maxWidth / constraints.maxHeight;
        final scale =
            containerRatio > previewRatio
                ? containerRatio / previewRatio
                : previewRatio / containerRatio;
        return Transform.scale(
          scale: scale,
          child: Center(child: CameraPreview(controller)),
        );
      },
    );
  }
}
