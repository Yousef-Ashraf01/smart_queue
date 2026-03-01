import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class ScanIdCardScreen extends StatefulWidget {
  const ScanIdCardScreen({super.key});

  @override
  State<ScanIdCardScreen> createState() => _ScanIdCardScreenState();
}

class _ScanIdCardScreenState extends State<ScanIdCardScreen> {
  File? _idImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _idImage = File(pickedFile.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _idImage = File(pickedFile.path));
    }
  }

  Future<void> _submit() async {
    if (_idImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select your ID")));
      return;
    }
    setState(() => _isUploading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ID uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        AppAssets.iconBack,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    SizedBox(width: 60),
                    Text(
                      "Scan ID Card",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text(
                "Take a photo of the front of your ID card",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Place your ID card in the frame below",
                style: AppStyle.medium14gray,
              ),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 320,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(color: Colors.black26, width: 1.5),
                        ),
                      ),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 300,
                          height: 180,
                          child:
                              _idImage != null
                                  ? Image.file(_idImage!, fit: BoxFit.cover)
                                  : Image.asset(
                                    AppAssets.imageIdCard,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(Icons.photo_library, _pickFromGallery),
                  _actionButton(
                    Icons.camera_alt,
                    _pickFromCamera,
                    active: true,
                  ),
                  _actionButton(
                    Icons.refresh,
                    () => setState(() => _idImage = null),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 40),
              //   child: SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: _isUploading ? null : _submit,
              //       style: ElevatedButton.styleFrom(
              //         padding: const EdgeInsets.symmetric(vertical: 16),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //       ),
              //       child:
              //           _isUploading
              //               ? const CircularProgressIndicator(
              //                 color: Colors.white,
              //               )
              //               : const Text(
              //                 "Verify / Submit",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    VoidCallback onTap, {
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: active ? Colors.green : Colors.white,
        foregroundColor: Colors.white,
        child: Icon(icon, color: active ? Colors.white : Colors.black87),
      ),
    );
  }
}
