import 'package:flutter/material.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/section_label.dart';

class AccountInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String countryCode;
  final void Function(String phone, String code) onPhoneChanged;

  const AccountInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.countryCode,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(text: "Account Info"),
        const SizedBox(height: 12),
        CustomTextField(
          label: "User name",
          controller: nameController,
          hint: 'Enter your full name',
        ),
        CustomTextField(
          label: "Email",
          hint: "Enter your email",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const FieldLabel(text: "Phone number"),
        PhoneInputField(
          controller: phoneController,
          initialCountryCode: countryCode,
          onChanged: onPhoneChanged,
        ),
      ],
    );
  }
}
