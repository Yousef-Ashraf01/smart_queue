import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/profile_settings/data/models/setting_option.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/profile_avatar_section.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  static const List<SettingOption> _accountOptions = [
    SettingOption(
      iconPath: AppAssets.iconUserSquare,
      title: 'Personal information',
      routeName: 'personal_info',
    ),
  ];

  static const List<SettingOption> _settingOptions = [
    SettingOption(
      iconPath: AppAssets.iconSetting,
      title: 'App settings',
      routeName: '',
    ),
    SettingOption(
      iconPath: AppAssets.iconMessageQuestion,
      title: 'Help and support center',
      routeName: '',
    ),
    SettingOption(
      iconPath: AppAssets.iconProfile2User,
      title: 'About us',
      routeName: '',
    ),
    SettingOption(
      iconPath: AppAssets.iconDocument,
      title: 'Terms and Policy',
      routeName: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
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
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: NotificationWidget(),
              ),
              Text('Profile Settings', style: AppStyle.appBarTitle),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const ProfileAvatarSection(
                      name: 'Mohamed Ayad',
                      email: 'mo3yad57@gmail.com',
                    ),
                    const SizedBox(height: 35),
                    const SectionHeader(title: 'Accounts'),
                    const SizedBox(height: 12),
                    SettingsListContainer(options: _accountOptions),
                    const SizedBox(height: 30),
                    const SectionHeader(title: 'Settings'),
                    const SizedBox(height: 12),
                    SettingsListContainer(options: _settingOptions),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: AppStyle.sectionHeader),
    );
  }
}

class SettingsListContainer extends StatelessWidget {
  final List<SettingOption> options;
  const SettingsListContainer({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(options.length, (index) {
          final item = options[index];
          return Column(
            children: [
              ListTile(
                onTap: () {
                  if (item.title == 'Personal information') {
                    context.push(AppRoutes.personalInfo);
                  }
                },
                leading: SvgPicture.asset(item.iconPath, width: 24),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: SvgPicture.asset(
                  AppAssets.iconChevronRight,
                  width: 14,
                ),
              ),
              if (index != options.length - 1)
                const Divider(
                  height: 1,
                  indent: 60,
                  endIndent: 20,
                  color: AppColors.dividerColor,
                ),
            ],
          );
        }),
      ),
    );
  }
}
