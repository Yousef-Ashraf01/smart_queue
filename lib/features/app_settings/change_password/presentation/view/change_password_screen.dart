import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/app_settings/change_password/presentation/cubit/change_password_cubit.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isCurrentHidden = true;
  bool _isNewHidden = true;
  bool _isConfirmHidden = true;

  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          AppFlushbar.show(
            context,
            message: "Password changed successfully",
            type: MessageType.success,
            duration: const Duration(milliseconds: 1500),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            context.pop();
          });
        }

        if (state is ChangePasswordError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 28),
                    onPressed: () => context.pop(),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "Enter your current password\nand set a new one",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const FieldLabel(text: "Current Password"),
                  _buildField(
                    controller: currentController,
                    hint: "Current Password",
                    isHidden: _isCurrentHidden,
                    onToggle: () {
                      setState(() {
                        _isCurrentHidden = !_isCurrentHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const FieldLabel(text: "New Password"),
                  _buildField(
                    controller: newController,
                    hint: "New Password",
                    isHidden: _isNewHidden,
                    onToggle: () {
                      setState(() {
                        _isNewHidden = !_isNewHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  const FieldLabel(text: "Confirm Password"),
                  _buildField(
                    controller: confirmController,
                    hint: "Confirm Password",
                    isHidden: _isConfirmHidden,
                    onToggle: () {
                      setState(() {
                        _isConfirmHidden = !_isConfirmHidden;
                      });
                    },
                  ),

                  const Spacer(),

                  BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      final isLoading = state is ChangePasswordLoading;

                      return _buildButton(
                        text: isLoading ? null : "Update Password",
                        isLoading: isLoading,
                        onTap:
                            isLoading
                                ? null
                                : () {
                                  _handleChangePassword(context);
                                },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        cursorColor: Colors.green[200],
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(isHidden ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    String? text,
    required VoidCallback? onTap,
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF63D98A), Color(0xFF1B4332)],
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    text ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
        ),
      ),
    );
  }

  void _handleChangePassword(BuildContext context) {
    final current = currentController.text.trim();
    final newPass = newController.text.trim();
    final confirm = confirmController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (newPass.length < 8) {
      _showError("Password must be at least 8 characters");
      return;
    }

    if (newPass != confirm) {
      _showError("Passwords do not match");
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(current, newPass);
  }

  void _showError(String msg) {
    AppFlushbar.show(context, message: msg, type: MessageType.warning);
  }
}
