import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/features/auth/data/models/client_model.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/forget_password/presentation/view/create_new_password_screen.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/app_button.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/date_fields_group.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/personal_info_shimmer.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/logout_dialog.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/profile_avatar_section.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();

  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  String countryCode = "20";

  ProfileModel? lastProfile;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<PersonalInfoCubit>();
    cubit.getProfile();
  }

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00BFA6),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00BFA6),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dayController.text = DateFormat('dd').format(picked);
        monthController.text = DateFormat('MM').format(picked);
        yearController.text = DateFormat('yyyy').format(picked);
      });
    }
  }

  void _fillControllers(ProfileModel profile) {
    nameController.text = profile.username;
    emailController.text = profile.email;
    idController.text = profile.client.nationalId;

    if (profile.client.phone != null && profile.client.phone!.isNotEmpty) {
      final fullPhone = profile.client.phone!;
      if (fullPhone.startsWith('+')) {
        countryCode = fullPhone.substring(1, 3);
        phoneController.text = fullPhone.substring(3);
      }
    }

    if (profile.client.birthDate != null &&
        profile.client.birthDate!.isNotEmpty) {
      final birthDate = DateTime.tryParse(profile.client.birthDate!);
      if (birthDate != null) {
        dayController.text = birthDate.day.toString().padLeft(2, '0');
        monthController.text = birthDate.month.toString().padLeft(2, '0');
        yearController.text = birthDate.year.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoCubit, PersonalInfoState>(
      listener: (context, state) {
        if (state is PersonalInfoLoaded) {
          lastProfile = state.profile;
          _fillControllers(state.profile);
        } else if (state is PersonalInfoUpdated) {
          lastProfile = state.profile;
          _fillControllers(state.profile);
          AppFlushbar.show(
            context,
            message: "Profile updated successfully",
            type: MessageType.success,
            duration: const Duration(seconds: 1),
          );
        } else if (state is PersonalInfoError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
          );
        } else if (state is AuthInitial) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        body: BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                  child: Column(
                    children: [
                      AppTopBar(),
                      Text('Personal information', style: AppStyle.appBarTitle),
                      const SizedBox(height: 20),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                ),
                if (state is PersonalInfoUpdating)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00BFA6),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
          builder: (context, state) {
            final isLoading = state is PersonalInfoUpdating;
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 25),
              child: AppButton(
                text: "Save Changes",
                isLoading: isLoading,
                backgroundColor: const Color(0xFF00BFA6),
                onPressed:
                    isLoading
                        ? null
                        : () {
                          final cubit = context.read<PersonalInfoCubit>();
                          final currentState = cubit.state;
                          if (currentState is! PersonalInfoLoaded) return;

                          final birthDate = DateTime(
                            int.parse(yearController.text),
                            int.parse(monthController.text),
                            int.parse(dayController.text),
                          );

                          final formattedDate = DateFormat(
                            'yyyy-MM-dd',
                          ).format(birthDate);

                          final updatedProfile = ProfileModel(
                            id: currentState.profile.id,
                            username: nameController.text,
                            email: emailController.text,
                            client: ClientModel(
                              nationalId: idController.text,
                              birthDate: formattedDate,
                              profession: "string",
                              gender: "F",
                              phone: "+$countryCode${phoneController.text}",
                            ),
                          );

                          cubit.updateProfile(updatedProfile);
                        },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (lastProfile == null) {
      return const PersonalInfoShimmer();
    }
    return _profileContent(lastProfile!);
  }

  Widget _profileContent(ProfileModel profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ProfileAvatarSection(
              name: profile.username,
              email: profile.email,
            ),
          ),
          const SizedBox(height: 25),
          CustomTextField(
            label: "Full name",
            controller: nameController,
            hint: 'Enter your full name',
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
            readOnly: true,
            label: "National ID",
            hint: "Enter your ID",
            controller: idController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const FieldLabel(text: "Phone number"),
          PhoneInputField(
            controller: phoneController,
            initialCountryCode: countryCode,
            onChanged: (phone, code) {
              countryCode = code;
            },
          ),
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
              LogoutDialog.show(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
