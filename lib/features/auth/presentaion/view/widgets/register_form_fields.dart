import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/date_fields_group.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';

class RegisterFormFields extends StatelessWidget {
  final bool hasIdData;

  final TextEditingController nameController;
  final TextEditingController nationalIdController;
  final TextEditingController addressController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final TextEditingController phoneController;

  final FocusNode nameFocus;
  final FocusNode nationalIdFocus;

  final void Function(String, String) onPhoneChanged;
  final void Function(String) onNationalIdChanged;
  final VoidCallback? onDateTap;

  const RegisterFormFields({
    super.key,
    required this.hasIdData,
    required this.nameController,
    required this.nationalIdController,
    required this.addressController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.phoneController,
    required this.nameFocus,
    required this.nationalIdFocus,
    required this.onPhoneChanged,
    required this.onNationalIdChanged,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasIdData) ...[
          CustomTextField(
            label: "Full Name",
            hint: "Enter your full name",
            controller: nameController,
            icon: Icons.person,
            focusNode: nameFocus,
            validator: (value) {
              if (value == null || value.isEmpty) return "Name is required";
              if (value.length < 3) return "Name must be at least 3 characters";
              return null;
            },
          ),
          CustomTextField(
            label: "National ID",
            hint: "Enter your 14-digit national ID",
            controller: nationalIdController,
            keyboardType: TextInputType.number,
            icon: Icons.badge,
            focusNode: nationalIdFocus,
            readOnly: hasIdData,
            onChanged: onNationalIdChanged,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (value) {
              if (value == null || value.isEmpty)
                return "National ID is required";
              if (!RegExp(r'^\d{14}$').hasMatch(value))
                return "National ID must be exactly 14 digits";
              return null;
            },
          ),
          CustomTextField(
            label: "Address",
            hint: "Enter your address",
            controller: addressController,
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.isEmpty) return "Address is required";
              return null;
            },
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "Birth Date",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 8),
          DateFieldsGroup(
            dayController: dayController,
            monthController: monthController,
            yearController: yearController,
            onTap: onDateTap,
          ),
          const SizedBox(height: 16),
        ],

        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Phone number",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 8),
        PhoneInputField(controller: phoneController, onChanged: onPhoneChanged),
        const SizedBox(height: 16),
      ],
    );
  }
}
