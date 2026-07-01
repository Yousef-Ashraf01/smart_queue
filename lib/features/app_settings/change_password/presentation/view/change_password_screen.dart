import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
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
    final ext = context.appTheme;
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          AppFlushbar.show(
            context,
            message: "password_changed_success".tr(),
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
            message: state.message.localizedApi,
            type: MessageType.error,
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ext.bgGradientTop, ext.bgGradientBottom],
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

                  Center(
                    child: Text(
                      "change_password".tr(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "change_password_subtitle".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ext.subtleText),
                    ),
                  ),

                  const SizedBox(height: 30),

                  FieldLabel(text: "current_password".tr()),
                  _buildField(
                    controller: currentController,
                    hint: "current_password".tr(),
                    isHidden: _isCurrentHidden,
                    onToggle: () {
                      setState(() {
                        _isCurrentHidden = !_isCurrentHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  FieldLabel(text: "new_password".tr()),
                  _buildField(
                    controller: newController,
                    hint: "new_password".tr(),
                    isHidden: _isNewHidden,
                    onToggle: () {
                      setState(() {
                        _isNewHidden = !_isNewHidden;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  FieldLabel(text: "confirm_password".tr()),
                  _buildField(
                    controller: confirmController,
                    hint: "confirm_password".tr(),
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
                        text: isLoading ? null : "update_password".tr(),
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
    final ext = context.appTheme;
    return Container(
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.greenStart.withOpacity(0.3)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: ext.subtleText.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          prefixIcon: Icon(Icons.lock_outline, color: ext.subtleText),
          suffixIcon: IconButton(
            icon: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
              color: ext.subtleText,
            ),
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
      _showError("fill_all_fields".tr());
      return;
    }

    if (newPass.length < 8) {
      _showError("password_length_error".tr());
      return;
    }

    if (newPass != confirm) {
      _showError("passwords_do_not_match".tr());
      return;
    }

    context.read<ChangePasswordCubit>().changePassword(current, newPass);
  }

  void _showError(String msg) {
    AppFlushbar.show(context, message: msg, type: MessageType.warning);
  }
}
