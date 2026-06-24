import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
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
            label: "full_name_label".tr(),
            hint: "full_name_hint".tr(),
            controller: nameController,
            icon: Icons.person_outline_rounded,
            focusNode: nameFocus,
            validator: (value) {
              if (value == null || value.isEmpty) return "full_name_required".tr();
              if (value.length < 3) return "full_name_min_length".tr();
              return null;
            },
          ),
          CustomTextField(
            label: "national_id_label".tr(),
            hint: "national_id_hint".tr(),
            controller: nationalIdController,
            keyboardType: TextInputType.number,
            icon: Icons.badge_outlined,
            focusNode: nationalIdFocus,
            readOnly: hasIdData,
            onChanged: onNationalIdChanged,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "national_id_required".tr();
              }
              if (!RegExp(r'^\d{14}$').hasMatch(value)) {
                return "national_id_invalid".tr();
              }
              return null;
            },
          ),
          CustomTextField(
            label: "address_label".tr(),
            hint: "address_hint".tr(),
            controller: addressController,
            icon: Icons.location_on_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) return "address_required".tr();
              return null;
            },
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "birth_date_label".tr(),
              style: const TextStyle(
                fontFamily: AppStyle.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.teal,
              ),
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
            "phone_number_label".tr(),
            style: const TextStyle(
              fontFamily: AppStyle.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.teal,
            ),
          ),
        ),
        const SizedBox(height: 8),
        PhoneInputField(controller: phoneController, onChanged: onPhoneChanged),
        const SizedBox(height: 16),
      ],
    );
  }
}
