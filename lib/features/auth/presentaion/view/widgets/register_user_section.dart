import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
          const Row(
            children: [
              Icon(Icons.edit_rounded, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                'Complete your profile',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.grey,
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
          label: "Username",
          hint: "Enter your username",
          controller: userNameController,
          icon: Icons.alternate_email_rounded,
          focusNode: userNameFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "Username is required";
            if (value.length < 3)
              return "Username must be at least 3 characters";
            if (value.length > 20) return "Username must be 20 characters max";
            if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value))
              return "Only letters, numbers and underscore allowed";
            return null;
          },
        ),

        CustomTextField(
          label: "Email",
          hint: "Enter your email",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          icon: Icons.email,
          focusNode: emailFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "Email is required";
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
              return "Enter a valid email";
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
          label: "Password",
          hint: "Enter your password",
          controller: passwordController,
          isPassword: true,
          icon: Icons.lock,
          focusNode: passwordFocus,
          validator: (value) {
            if (value == null || value.isEmpty) return "Password is required";
            if (value.length < 8)
              return "Password must be at least 8 characters";
            if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value))
              return "Password must contain letters & numbers";
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
                text: "Register",
                onTap: onRegister,
                isLoading: state is AuthLoading,
              ),
        ),

        const SizedBox(height: 20),

        Center(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: 'Login',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () => context.pop(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
