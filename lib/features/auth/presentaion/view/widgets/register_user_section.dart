import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/image_picker_section.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/image_source_sheet.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/register_form_fields.dart';

class RegisterUserSection extends StatelessWidget {
  final bool hasIdData;
  final XFile? pickedImage;

  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController nationalIdController;
  final TextEditingController addressController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController phoneController;

  final FocusNode userNameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode nameFocus;
  final FocusNode nationalIdFocus;

  final Future<void> Function(ImageSource) onPickImage;
  final void Function(String, String) onPhoneChanged;
  final void Function(String) onNationalIdChanged;
  final VoidCallback? onDateTap;
  final VoidCallback onRegister;

  const RegisterUserSection({
    super.key,
    required this.hasIdData,
    required this.pickedImage,
    required this.userNameController,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.nationalIdController,
    required this.addressController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.phoneController,
    required this.userNameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.nameFocus,
    required this.nationalIdFocus,
    required this.onPickImage,
    required this.onPhoneChanged,
    required this.onNationalIdChanged,
    required this.onRegister,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasIdData) ...[
          Row(
            children: [
              Icon(
                Icons.edit_rounded,
                size: 16,
                color:
                    context.isDark ? Colors.green[300]! : AppColors.tealMuted,
              ),
              const SizedBox(width: 6),
              Text(
                'complete_profile'.tr(),
                style: TextStyle(
                  fontFamily: AppStyle.fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color:
                      context.isDark ? Colors.green[300]! : AppColors.tealMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        ImagePickerSection(
          pickedImage: pickedImage,
          onTap: () => ImageSourceSheet.show(context, onPickImage: onPickImage),
        ),
        const SizedBox(height: 24),

        CustomTextField(
          label: "username_label".tr(),
          hint: "username_hint".tr(),
          controller: userNameController,
          icon: Icons.alternate_email_rounded,
          focusNode: userNameFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "username_required".tr();
            if (value.length < 3) return "username_min_length".tr();
            if (value.length > 20) return "username_max_length".tr();
            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
              return "username_invalid".tr();
            }
            return null;
          },
        ),

        CustomTextField(
          label: "email_label".tr(),
          hint: "email_hint".tr(),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email_outlined,
          focusNode: emailFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "email_required".tr();
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "email_invalid".tr();
            }
            return null;
          },
        ),

        RegisterFormFields(
          hasIdData: hasIdData,
          nameController: nameController,
          nationalIdController: nationalIdController,
          addressController: addressController,
          dayController: dayController,
          monthController: monthController,
          yearController: yearController,
          phoneController: phoneController,
          nameFocus: nameFocus,
          nationalIdFocus: nationalIdFocus,
          onPhoneChanged: onPhoneChanged,
          onNationalIdChanged: onNationalIdChanged,
          onDateTap: onDateTap,
        ),

        CustomTextField(
          label: "password_label".tr(),
          hint: "password_hint".tr(),
          controller: passwordController,
          isPassword: true,
          icon: Icons.lock_outline_rounded,
          focusNode: passwordFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "password_required".tr();
            if (value.length < 8) return "password_length_error".tr();
            if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
              return "password_format_error".tr();
            }
            return null;
          },
        ),

        const SizedBox(height: 10),

        BlocBuilder<AuthCubit, AuthState>(
          buildWhen:
              (previous, current) =>
                  current is AuthLoading ||
                  current is AuthError ||
                  current is RegisterSuccess,
          builder:
              (context, state) => GradientButton(
                text: "register".tr(),
                onTap: onRegister,
                isLoading: state is AuthLoading,
              ),
        ),

        const SizedBox(height: 24),

        Center(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: AppStyle.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: 'already_have_account'.tr(),
                  style: TextStyle(color: context.appTheme.subtleText),
                ),
                TextSpan(
                  text: 'login'.tr(),
                  style: TextStyle(
                    color: context.isDark ? Colors.green[300]! : AppColors.teal,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => context.push(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
