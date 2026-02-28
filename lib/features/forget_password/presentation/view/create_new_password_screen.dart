import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/widgets/status_bar_scaffold.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return StatusBarScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 30),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Create New Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Your new password must be different\nfrom previously used password',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF8E8E93)),
              ),
            ),
            const SizedBox(height: 40),

            const FieldLabel(text: "New Password"),
            _buildPasswordField(
              hint: "Password",
              isHidden: _isPasswordHidden,
              onToggle: () {
                setState(() {
                  _isPasswordHidden = !_isPasswordHidden;
                });
              },
            ),

            const SizedBox(height: 20),

            const FieldLabel(text: "Confirm Password"),
            _buildPasswordField(
              hint: "Password",
              isHidden: _isConfirmPasswordHidden,
              onToggle: () {
                setState(() {
                  _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                });
              },
            ),

            const Spacer(),

            _buildGradientButton("Send", () {

            }),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: isHidden,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFC7C7CC)),

          prefixIcon: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.lock_outline_rounded, color: Color(0xFFC7C7CC)),
                const SizedBox(width: 12),
                VerticalDivider(
                  color: const Color(0x7FC7C7CC),
                  thickness: 1,
                  indent: 14,
                  endIndent: 14,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: const Color(0xFFC7C7CC),
                size: 22,
              ),
              onPressed: onToggle,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF63D98A), Color(0xFF1B4332)],
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}