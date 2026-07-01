import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  bool locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 28),
                  onPressed: () => context.pop(),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text("app_settings".tr(), style: AppStyle.appBarTitle),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSectionTitle("preferences".tr()),

                      const SizedBox(height: 12),

                      _buildCard([
                        _buildSwitchTile(
                          title: "dark_mode".tr(),
                          icon: Icons.dark_mode_outlined,
                          value: isDarkMode,
                          onChanged: (val) {
                            setState(() => isDarkMode = val);
                          },
                        ),
                        _divider(),
                        _buildSwitchTile(
                          title: "notifications".tr(),
                          icon: Icons.notifications_none,
                          value: notificationsEnabled,
                          onChanged: (val) {
                            setState(() => notificationsEnabled = val);
                          },
                        ),
                        _divider(),
                        _buildSwitchTile(
                          title: "location_access".tr(),
                          icon: Icons.location_on_outlined,
                          value: locationEnabled,
                          onChanged: (val) {
                            setState(() => locationEnabled = val);
                          },
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _buildSectionTitle("app_section".tr()),

                      const SizedBox(height: 12),

                      _buildCard([
                        _buildSimpleTile(
                          title: "language".tr(),
                          icon: Icons.language,
                          value:
                              context.locale.languageCode == 'ar'
                                  ? 'arabic_language'.tr()
                                  : 'english_language'.tr(),
                          onTap: _showLanguageDialog,
                        ),
                        _divider(),

                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          title: Text(
                            "change_password".tr(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            context.push(AppRoutes.changePassword);
                          },
                        ),
                        _divider(),
                        _buildSimpleTile(
                          title: "app_version".tr(),
                          icon: Icons.info_outline,
                          value: "1.0.0",
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_language'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2D35),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'english_language'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing:
                      context.locale.languageCode == 'en'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: AppColors.dividerColor),
                ListTile(
                  title: Text(
                    'arabic_language'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing:
                      context.locale.languageCode == 'ar'
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                  onTap: () {
                    context.setLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 50,
      endIndent: 20,
      color: AppColors.dividerColor,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildSimpleTile({
    required String title,
    required IconData icon,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
