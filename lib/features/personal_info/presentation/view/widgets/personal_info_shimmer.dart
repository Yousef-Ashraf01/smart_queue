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
      children: [_label(), _textFieldBox(), const SizedBox(height: 16)],
    );
  }

  Widget _sectionLabel() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 100,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _readOnlyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _textLine(height: 14)),
          const SizedBox(width: 12),
          Container(width: 16, height: 16, color: Colors.white),
        ],
      ),
    );
  }

  Widget _addressCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(width: 20, height: 20, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textLine(width: 60, height: 12),
                  const SizedBox(height: 4),
                  _textLine(height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarSection() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _textLine(width: 140, height: 16),
        const SizedBox(height: 6),
        _textLine(width: 180, height: 14),
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

            _sectionLabel(),
            const SizedBox(height: 12),
            _customField(),
            _customField(),
            _label(),
            _textFieldBox(),
            const SizedBox(height: 24),

            _sectionLabel(),
            const SizedBox(height: 12),
            _textLine(width: 90, height: 13),
            const SizedBox(height: 8),
            _readOnlyCard(),
            const SizedBox(height: 12),
            _textLine(width: 80, height: 13),
            const SizedBox(height: 8),
            _readOnlyCard(),
            const SizedBox(height: 16),

            _sectionLabel(),
            const SizedBox(height: 12),
            _addressCard(),
            const SizedBox(height: 40),

            _button(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
