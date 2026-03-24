import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInfoShimmer extends StatelessWidget {
  const PersonalInfoShimmer({super.key});

  Widget _textLine({double width = double.infinity, double height = 14}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _textFieldBox() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _label() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_textLine(width: 100, height: 14), const SizedBox(height: 8)],
    );
  }

  Widget _customField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_label(), _textFieldBox(), const SizedBox(height: 18)],
    );
  }

  Widget _dateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textLine(width: 80, height: 14),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _textFieldBox()),
            const SizedBox(width: 10),
            Expanded(child: _textFieldBox()),
            const SizedBox(width: 10),
            Expanded(child: _textFieldBox()),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _button() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _avatarSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: Colors.white,
              ),
            ),
            // Container(
            //   width: 32,
            //   height: 32,
            //   decoration: const BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 12),
        _textLine(width: 140, height: 16),
        const SizedBox(height: 6),
        _textLine(width: 180, height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Center(child: _avatarSection()),

            const SizedBox(height: 25),

            _customField(),
            _customField(),
            _customField(),
            _customField(),

            _dateFields(),

            const SizedBox(height: 40),

            _button(),
          ],
        ),
      ),
    );
  }
}
