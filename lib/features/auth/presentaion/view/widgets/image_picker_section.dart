import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
                    color: Colors.white,
                    border: Border.all(
                      color:
                          pickedImage != null
                              ? const Color.fromARGB(255, 118, 226, 136)
                              : Colors.grey.shade300,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          11,
                          58,
                          30,
                        ).withOpacity(0.12),
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
                                    color: const Color.fromARGB(
                                      255,
                                      118,
                                      226,
                                      136,
                                    ).withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 26,
                                    color: Color.fromARGB(255, 11, 58, 30),
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 118, 226, 136),
                          Color.fromARGB(255, 11, 58, 30),
                        ],
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
              pickedImage != null ? 'Change Photo' : 'Add Profile Photo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    pickedImage != null
                        ? const Color.fromARGB(255, 11, 58, 30)
                        : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
