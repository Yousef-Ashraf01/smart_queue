import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/scan_id_card/presentation/cubit/id_cubit.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/camera_section.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/capture_button.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/error_bottom_sheet.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/header.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/reading_overlay.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/subtitle.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/tips_row.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/verify_button.dart';

class ScanIdCardScreen extends StatefulWidget {
  const ScanIdCardScreen({super.key});

  @override
  State<ScanIdCardScreen> createState() => _ScanIdCardScreenState();
}

class _ScanIdCardScreenState extends State<ScanIdCardScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  bool _isCameraReady = false;
  File? _capturedImage;
  final GlobalKey _frameKey = GlobalKey();
  final GlobalKey _cameraKey = GlobalKey();

  late AnimationController _scanAnim;
  late AnimationController _captureAnim;
  late AnimationController _fadeAnim;

  @override
  void initState() {
    super.initState();

    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _captureAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _fadeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();

    final cameras = await availableCameras();
    final controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isCameraReady = true;
      });
    } catch (e) {
      await controller.dispose();
    }
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      await _captureAnim.forward();
      await _captureAnim.reverse();

      final file = await controller.takePicture();
      await controller.pausePreview();

      if (!mounted) return;

      final cropped = await _cropToFrame(File(file.path));

      setState(() => _capturedImage = cropped);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<File> _cropToFrame(File imageFile) async {
    final RenderBox? frameBox =
        _frameKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cameraBox =
        _cameraKey.currentContext?.findRenderObject() as RenderBox?;

    if (frameBox == null || cameraBox == null) return imageFile;

    final frameOffset = frameBox.localToGlobal(Offset.zero);
    final cameraOffset = cameraBox.localToGlobal(Offset.zero);

    final frameRect = Rect.fromLTWH(
      frameOffset.dx - cameraOffset.dx,
      frameOffset.dy - cameraOffset.dy,
      frameBox.size.width,
      frameBox.size.height,
    );

    final cameraSize = cameraBox.size;

    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageFile;

    final scaleX = image.width / cameraSize.width;
    final scaleY = image.height / cameraSize.height;

    final cropX = (frameRect.left * scaleX).toInt();
    final cropY = (frameRect.top * scaleY).toInt();
    final cropW = (frameRect.width * scaleX).toInt();
    final cropH = (frameRect.height * scaleY).toInt();

    final cropped = img.copyCrop(
      image,
      x: cropX.clamp(0, image.width),
      y: cropY.clamp(0, image.height),
      width: cropW.clamp(1, image.width - cropX),
      height: cropH.clamp(1, image.height - cropY),
    );

    final croppedFile = File(
      '${imageFile.parent.path}/cropped_${imageFile.uri.pathSegments.last}',
    );
    await croppedFile.writeAsBytes(img.encodeJpg(cropped));
    return croppedFile;
  }

  void _submit() async {
    if (_capturedImage == null) return;

    await _controller?.dispose();
    _controller = null;

    if (!mounted) return;

    context.read<IdCubit>().extractId(_capturedImage!);
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    _captureAnim.dispose();
    _fadeAnim.dispose();

    final controller = _controller;
    _controller = null;

    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IdCubit, IdState>(
      listener: (context, state) async {
        if (state is IdSuccess) {
          context.push(AppRoutes.register, extra: state.data);
        } else if (state is IdError) {
          setState(() => _capturedImage = null);
          await _initCamera();
          if (mounted) ErrorBottomSheet.show(context, state.message);
        }
      },
      child: Scaffold(
        body: BlocBuilder<IdCubit, IdState>(
          builder: (context, state) {
            final isLoading = state is IdLoading;
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.bgTop, AppColors.bgBottom],
                    ),
                  ),
                  child: SafeArea(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const Header(),
                          const SizedBox(height: 6),
                          const Subtitle(),
                          const SizedBox(height: 14),
                          Expanded(
                            child: CameraSection(
                              isCameraReady: _isCameraReady,
                              controller: _controller,
                              scanAnim: _scanAnim,
                              capturedImage: _capturedImage,
                              frameKey: _frameKey,
                              cameraKey: _cameraKey,
                            ),
                          ),
                          const TipsRow(),
                          const SizedBox(height: 16),
                          CaptureButton(
                            captureAnim: _captureAnim,
                            onTap: _takePicture,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap to capture',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.tealMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          VerifyButton(
                            enabled: _capturedImage != null,
                            onTap: _submit,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading) const ReadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }
}
