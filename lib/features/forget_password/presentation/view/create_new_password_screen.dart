import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/forget_password/presentation/cubit/forget_password_cubit.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String sessionToken;

  const CreateNewPasswordScreen({super.key, required this.sessionToken});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: _passwordController,
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
                  hint: "Confirm Password",
                  controller: _confirmPasswordController,
                  isHidden: _isConfirmPasswordHidden,
                  onToggle: () {
                    setState(() {
                      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                    });
                  },
                ),

                const Spacer(),

                BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                  listener: (context, state) {
                    if (state is ForgetPasswordConfirmSuccess) {
                      AppFlushbar.show(
                        context,
                        message:
                            "Password reset successfully! Please log in with your new password.",
                        type: MessageType.success,
                        duration: const Duration(milliseconds: 1500),
                      );
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        context.go(AppRoutes.login);
                      });
                    } else if (state is ForgetPasswordError) {
                      AppFlushbar.show(
                        context,
                        message: state.message,
                        type: MessageType.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    return _buildGradientButton(
                      "Send",
                      state is ForgetPasswordLoading
                          ? null
                          : () {
                            FocusScope.of(context).unfocus();
                            final password = _passwordController.text;
                            final confirmPassword =
                                _confirmPasswordController.text;

                            if (password.isEmpty || confirmPassword.isEmpty) {
                              AppFlushbar.show(
                                context,
                                message: "Please enter both password fields",
                                type: MessageType.error,
                              );
                              return;
                            }

                            if (password.length < 8) {
                              AppFlushbar.show(
                                context,
                                message:
                                    "Password must be at least 8 characters long",
                                type: MessageType.error,
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              AppFlushbar.show(
                                context,
                                message: "Passwords do not match",
                                type: MessageType.error,
                              );
                              return;
                            }

                            context
                                .read<ForgetPasswordCubit>()
                                .resetPasswordConfirm(
                                  sessionToken: widget.sessionToken,
                                  newPassword: password,
                                );
                          },
                      isLoading: state is ForgetPasswordLoading,
                    );
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
    required bool isHidden,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        cursorColor: AppColors.greenStart,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFC7C7CC)),
          prefixIcon: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 16),
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFFC7C7CC),
                ),
                const SizedBox(width: 12),
                const VerticalDivider(
                  color: Color(0x7FC7C7CC),
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
                isHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
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

  Widget _buildGradientButton(
    String text,
    VoidCallback? onTap, {
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        margin: const EdgeInsets.only(bottom: 40, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors:
                isLoading
                    ? [Colors.grey, Colors.grey.shade700]
                    : const [Color(0xFF63D98A), Color(0xFF1B4332)],
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
