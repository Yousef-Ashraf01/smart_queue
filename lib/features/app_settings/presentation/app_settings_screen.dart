import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/theme/theme_cubit.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final isDark = context.isDark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ext.bgGradientTop, ext.bgGradientBottom],
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
                  icon: SvgPicture.asset(
                    AppAssets.iconArrowLeft,
                    width: 28,
                    colorFilter: isDark
                        ? const ColorFilter.mode(
                            Color(0xFFE6EDF3), BlendMode.srcIn)
                        : null,
                  ),
                  onPressed: () => context.pop(),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "app_settings".tr(),
                    style: AppStyle.appBarTitle.copyWith(
                      color: isDark
                          ? const Color(0xFFE6EDF3)
                          : AppColors.blackText,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSectionTitle("preferences".tr(), isDark),

                      const SizedBox(height: 12),

                      _buildCard(
                        isDark: isDark,
                        ext: ext,
                        children: [
                          // Dark Mode tile — reads from ThemeCubit
                          BlocBuilder<ThemeCubit, ThemeMode>(
                            builder: (context, themeMode) {
                              return _buildSwitchTile(
                                title: "dark_mode".tr(),
                                icon: isDark
                                    ? Icons.dark_mode
                                    : Icons.dark_mode_outlined,
                                value: themeMode == ThemeMode.dark,
                                isDark: isDark,
                                onChanged: (_) =>
                                    context.read<ThemeCubit>().toggleTheme(),
                              );
                            },
                          ),
                          _divider(isDark),
                          _buildSwitchTile(
                            title: "notifications".tr(),
                            icon: Icons.notifications_none,
                            value: notificationsEnabled,
                            isDark: isDark,
                            onChanged: (val) =>
                                setState(() => notificationsEnabled = val),
                          ),
                          _divider(isDark),
                          _buildSwitchTile(
                            title: "location_access".tr(),
                            icon: Icons.location_on_outlined,
                            value: locationEnabled,
                            isDark: isDark,
                            onChanged: (val) =>
                                setState(() => locationEnabled = val),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _buildSectionTitle("app_section".tr(), isDark),

                      const SizedBox(height: 12),

                      _buildCard(
                        isDark: isDark,
                        ext: ext,
                        children: [
                          _buildSimpleTile(
                            title: "language".tr(),
                            icon: Icons.language,
                            isDark: isDark,
                            value: context.locale.languageCode == 'ar'
                                ? 'arabic_language'.tr()
                                : 'english_language'.tr(),
                            onTap: _showLanguageDialog,
                          ),
                          _divider(isDark),
                          ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: isDark
                                  ? const Color(0xFF8B949E)
                                  : Colors.grey,
                            ),
                            title: Text(
                              "change_password".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? const Color(0xFFE6EDF3)
                                    : null,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: isDark
                                  ? const Color(0xFF8B949E)
                                  : Colors.grey,
                            ),
                            onTap: () => context.push(AppRoutes.changePassword),
                          ),
                          _divider(isDark),
                          _buildSimpleTile(
                            title: "app_version".tr(),
                            icon: Icons.info_outline,
                            isDark: isDark,
                            value: "1.0.0",
                          ),
                        ],
                      ),
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
    final isDark = context.isDark;
    final ext = context.appTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: ext.cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: ext.cardBorder.withOpacity(0.3)),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF30363D)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'select_language'.tr(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE6EDF3)
                        : const Color(0xFF0D2D35),
                  ),
                ),
                const SizedBox(height: 16),
                _languageTile(
                  ctx: ctx,
                  label: 'english_language'.tr(),
                  locale: const Locale('en'),
                  isDark: isDark,
                ),
                Divider(
                  color: isDark
                      ? const Color(0xFF21262D)
                      : AppColors.dividerColor,
                ),
                _languageTile(
                  ctx: ctx,
                  label: 'arabic_language'.tr(),
                  locale: const Locale('ar'),
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageTile({
    required BuildContext ctx,
    required String label,
    required Locale locale,
    required bool isDark,
  }) {
    final isSelected = ctx.locale.languageCode == locale.languageCode;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFE6EDF3) : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.primary)
          : null,
      onTap: () {
        ctx.setLocale(locale);
        Navigator.pop(ctx);
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? const Color(0xFF8B949E) : AppColors.greyText,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildCard({
    required List<Widget> children,
    required bool isDark,
    required AppThemeExtension ext,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(color: ext.cardBorder, width: 1)
            : Border.all(color: Colors.white.withOpacity(0.8), width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 50,
      endIndent: 20,
      color: isDark ? const Color(0xFF21262D) : AppColors.dividerColor,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required bool isDark,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? const Color(0xFF8B949E) : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFE6EDF3) : null,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
      ),
    );
  }

  Widget _buildSimpleTile({
    required String title,
    required IconData icon,
    required String value,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    final subtleColor =
        isDark ? const Color(0xFF8B949E) : Colors.grey;
    return ListTile(
      leading: Icon(icon, color: subtleColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFE6EDF3) : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: subtleColor)),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios,
                size: 14, color: subtleColor),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
