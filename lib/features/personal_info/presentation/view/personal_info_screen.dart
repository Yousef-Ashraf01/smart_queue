import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/app_top_bar.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/account_info_section.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/address_section.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/app_button.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/personal_info_section.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/personal_info_shimmer.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/save_changes_button.dart';
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

  XFile? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked != null) setState(() => _pickedImage = picked);
  }

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
            message: "profile_updated_successfully".tr(),
            type: MessageType.success,
            duration: const Duration(seconds: 1),
          );
        } else if (state is PersonalInfoError) {
          AppFlushbar.show(
            context,
            message: state.message.localizedApi,
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.appTheme.bgGradientTop,
                        context.appTheme.bgGradientBottom,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                  child: Column(
                    children: [
                      AppTopBar(),
                      Text(
                        'personal_info_title'.tr(),
                        style: AppStyle.appBarTitle.adaptive(context),
                      ),
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
        bottomNavigationBar: SaveChangesButton(
          nameController: nameController,
          emailController: emailController,
          idController: idController,
          phoneController: phoneController,
          dayController: dayController,
          monthController: monthController,
          yearController: yearController,
          countryCode: countryCode,
          pickedImage: _pickedImage,
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
    final items = [
      Center(
        child: ProfileAvatarSection(
          name: profile.username,
          email: profile.email,
          imageUrl: profile.client.imageUrl,
          onCameraTap: _pickImage,
          pickedImage: _pickedImage,
        ),
      ),
      const SizedBox(height: 25),

      AccountInfoSection(
        nameController: nameController,
        emailController: emailController,
        phoneController: phoneController,
        countryCode: countryCode,
        onPhoneChanged: (phone, code) => countryCode = code,
      ),
      const SizedBox(height: 24),

      PersonalInfoSection(
        nationalId: idController.text,
        day: dayController.text,
        month: monthController.text,
        year: yearController.text,
      ),
      const SizedBox(height: 16),

      if (profile.client.address != null)
        AddressSection(address: profile.client.address!),

      const SizedBox(height: 40),

      AppButton(
        text: "logout_title".tr(),
        iconPath: AppAssets.iconloginout,
        backgroundColor: Theme.of(context).colorScheme.error,
        onPressed: () => LogoutDialog.show(context),
      ),
      const SizedBox(height: 20),
    ];

    return AnimationLimiter(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 250),
              child:
                  index == 0
                      ? FadeInAnimation(
                        child: ScaleAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: items[index],
                        ),
                      )
                      : SlideAnimation(
                        verticalOffset: 20,
                        child: FadeInAnimation(child: items[index]),
                      ),
            );
          }),
        ),
      ),
    );
  }
}
