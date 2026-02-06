import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'custom_text_field.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;

  const PhoneInputField({super.key, required this.controller});

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {

  String countryCode = "20";
  String countryFlag = "🇪🇬";

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
                  style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF8E8E93)),
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
          ),
        ),
      ],
    );
  }
}