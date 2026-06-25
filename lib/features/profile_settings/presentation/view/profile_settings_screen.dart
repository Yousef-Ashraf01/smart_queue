import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';
import 'package:smart_queue/features/profile_settings/data/models/setting_option.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/logout_dialog.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/profile_avatar_section_read_only.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/widgets/profile_avatar_shimmer.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  static const List<SettingOption> _accountOptions = [
    SettingOption(
      iconPath: AppAssets.iconUserSquare,
      title: 'Personal information',
      routeName: 'personal_info',
    ),
    SettingOption(
      title: 'My Appointments',
      iconPath: AppAssets.iconBookmark,
      routeName: 'my_appointments',
    ),
  ];

  static const List<SettingOption> _settingOptions = [
    SettingOption(
      iconPath: AppAssets.iconSetting,
      title: 'App settings',
      routeName: 'app_settings',
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
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final XFile? _pickedImage = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Top Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D4E),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage your account and app preferences',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const NotificationWidget(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Scrollable Body ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 35),
                child: Column(
                  children: [
                    // Profile Info Header
                    BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                      builder: (context, state) {
                        if (state is PersonalInfoLoaded) {
                          return ProfileAvatarSectionReadOnly(
                            name: state.profile.username,
                            email: state.profile.email,
                            imageUrl: state.profile.client.imageUrl,
                            pickedImage: _pickedImage,
                          );
                        }

                        if (state is PersonalInfoLoading) {
                          return const ProfileAvatarShimmer();
                        }

                        return const SizedBox();
                      },
                    ),

                    const SizedBox(height: 32),

                    // Account Section
                    const SectionHeader(title: 'Account Settings'),
                    const SizedBox(height: 12),
                    SettingsListContainer(
                      options: ProfileSettingsScreen._accountOptions,
                    ),

                    const SizedBox(height: 28),

                    // App Settings Section
                    const SectionHeader(title: 'App Preferences'),
                    const SizedBox(height: 12),
                    SettingsListContainer(
                      options: ProfileSettingsScreen._settingOptions,
                      showLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF5B6BF5),
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class SettingsListContainer extends StatelessWidget {
  final List<SettingOption> options;
  final bool showLogout;

  const SettingsListContainer({
    super.key,
    required this.options,
    this.showLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
      ),
      child: Column(
        children: [
          ...List.generate(options.length, (index) {
            final item = options[index];
            return _buildTile(
              context: context,
              title: item.title,
              iconPath: item.iconPath,
              color: _getIconColor(item.title),
              onTap: () => _handleTap(context, item.title),
              isLast: index == options.length - 1 && !showLogout,
            );
          }),
          if (showLogout)
            _buildTile(
              context: context,
              title: 'Log out',
              iconPath: AppAssets.iconloginout,
              color: const Color(0xFFEF4444),
              textColor: const Color(0xFFEF4444),
              onTap: () => LogoutDialog.show(context),
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String title,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
    Color? textColor,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: textColor ?? const Color(0xFF1A1D4E),
            ),
          ),
          trailing:
              textColor != null
                  ? null
                  : Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.06),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppAssets.iconChevronRight,
                      width: 12,
                      colorFilter: ColorFilter.mode(
                        Colors.grey[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }

  Color _getIconColor(String title) {
    switch (title) {
      case 'Personal information':
        return const Color(0xFF3B82F6); // Vibrant Blue
      case 'My Appointments':
        return const Color(0xFFF59E0B); // Amber
      case 'App settings':
        return const Color(0xFF10B981); // Emerald
      case 'Help and support center':
        return const Color(0xFF8B5CF6); // Purple
      case 'About us':
        return const Color(0xFF06B6D4); // Cyan
      case 'Terms and Policy':
        return const Color(0xFF64748B); // Slate
      default:
        return const Color(0xFF5B6BF5); // Indigo default
    }
  }

  void _handleTap(BuildContext context, String title) {
    if (title == 'Personal information') {
      context.push(AppRoutes.personalInfo);
    } else if (title == 'App settings') {
      context.push(AppRoutes.appSettings);
    } else if (title == 'Help and support center') {
      context.push(AppRoutes.helpSupport);
    } else if (title == 'About us') {
      context.push(AppRoutes.aboutUs);
    } else if (title == 'Terms and Policy') {
      context.push(AppRoutes.termsAndPolicy);
    } else if (title == 'My Appointments') {
      context.push(AppRoutes.myAppointments);
    }
  }
}
