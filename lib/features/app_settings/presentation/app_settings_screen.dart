import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
                  child: Text("App Settings", style: AppStyle.appBarTitle),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSectionTitle("Preferences"),

                      const SizedBox(height: 12),

                      _buildCard([
                        _buildSwitchTile(
                          title: "Dark Mode",
                          icon: Icons.dark_mode_outlined,
                          value: isDarkMode,
                          onChanged: (val) {
                            setState(() => isDarkMode = val);
                          },
                        ),
                        _divider(),
                        _buildSwitchTile(
                          title: "Notifications",
                          icon: Icons.notifications_none,
                          value: notificationsEnabled,
                          onChanged: (val) {
                            setState(() => notificationsEnabled = val);
                          },
                        ),
                        _divider(),
                        _buildSwitchTile(
                          title: "Location Access",
                          icon: Icons.location_on_outlined,
                          value: locationEnabled,
                          onChanged: (val) {
                            setState(() => locationEnabled = val);
                          },
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _buildSectionTitle("App"),

                      const SizedBox(height: 12),

                      _buildCard([
                        _buildSimpleTile(
                          title: "Language",
                          icon: Icons.language,
                          value: "English",
                        ),
                        _divider(),

                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          title: const Text(
                            "Change Password",
                            style: TextStyle(fontWeight: FontWeight.w500),
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
                          title: "App Version",
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
      child: Column(children: children),
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
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }
}
