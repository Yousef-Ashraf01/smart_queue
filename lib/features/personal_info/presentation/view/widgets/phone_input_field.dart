import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/custom_text_field.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? initialCountryCode;
  final void Function(String phone, String countryCode)? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.initialCountryCode,
    this.onChanged,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late String countryCode;
  String countryFlag = "🇪🇬";

  @override
  void initState() {
    super.initState();
    countryCode = widget.initialCountryCode ?? "20";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                setState(() {
                  countryCode = country.phoneCode;
                  countryFlag = country.flagEmoji;
                });
                widget.onChanged?.call(widget.controller.text, countryCode);
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(countryFlag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  "+$countryCode",
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 15,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF8E8E93),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            hintText: "Phone number",
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Phone number is required";
              }
              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return "Phone must be 11 digits";
              }
              return null;
            },
            onChanged: (val) {
              widget.onChanged?.call(val, countryCode);
            },
          ),
        ),
      ],
    );
  }
}
