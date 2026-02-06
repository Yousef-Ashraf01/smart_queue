import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/widgets/custom_app_bar.dart';
import 'package:smart_queue/core/widgets/status_bar_scaffold.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/app_button.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/date_fields_group.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/profile_avatar_section.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final nameController = TextEditingController(text: "Mohamed Ayad");
  final emailController = TextEditingController(text: "mo3yad57@gmail.com");
  final idController = TextEditingController();
  final phoneController = TextEditingController();

  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    idController.dispose();
    phoneController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dayController.text = DateFormat('dd').format(picked);
        monthController.text = DateFormat('MM').format(picked);
        yearController.text = DateFormat('yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarScaffold(
      child: Column(
        children: [
          CustomAppBar(
            title: 'Personal information',
            showNotificationDot: true,
            onNotificationPress: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: ProfileAvatarSection(
                      name: 'Mohamed Ayad',
                      email: 'mo3yad57@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 25),

                  CustomTextField(
                    label: "Full name",
                    controller: nameController, hint: 'Enter your full name',
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Email",
                    hint: "Enter your email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "ID",
                    hint: "Enter your ID",
                    controller: idController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  const FieldLabel(text: "Phone number"),
                  PhoneInputField(controller: phoneController),
                  const SizedBox(height: 16),

                  const FieldLabel(text: "Birth date"),
                  DateFieldsGroup(
                    dayController: dayController,
                    monthController: monthController,
                    yearController: yearController,
                    onTap: _selectDate,
                  ),

                  const SizedBox(height: 40),

                  AppButton(
                    text: "Log out",
                    iconPath: AppAssets.iconloginout,
                    backgroundColor: Colors.red,
                    onPressed: () {
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}