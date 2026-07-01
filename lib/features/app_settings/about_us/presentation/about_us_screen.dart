import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.appTheme.bgGradientTop,
              context.appTheme.bgGradientBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    AppAssets.iconBack,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "about_us_header".tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.appTheme.subtleText,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ext.cardColor,
                          ),
                          child: Icon(
                            Icons.apartment,
                            size: 50,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Smart Queue",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${"app_version".tr()} 1.0.0",
                              style: TextStyle(color: ext.subtleText),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      _card(
                        Text(
                          "about_us_desc".tr(),
                          style: TextStyle(color: ext.subtleText, height: 1.5),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("our_mission_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "our_mission_desc".tr(),
                          style: TextStyle(color: ext.subtleText, height: 1.5),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("key_features_title".tr(), context),
                      const SizedBox(height: 10),

                      _card(
                        Column(
                          children: [
                            _featureItem("feature_1".tr()),
                            Divider(color: ext.cardBorder),
                            _featureItem("feature_2".tr()),
                            Divider(color: ext.cardBorder),
                            _featureItem("feature_3".tr()),
                            Divider(color: ext.cardBorder),
                            _featureItem("feature_4".tr()),
                          ],
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("developer_title".tr(), context),
                      const SizedBox(height: 10),

                      _card(
                        ListTile(
                          leading: Icon(Icons.person, color: ext.subtleText),
                          title: Text(
                            "dev_team".tr(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            "dev_role".tr(),
                            style: TextStyle(color: ext.subtleText),
                          ),
                          trailing: const Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
                        ),
                        context,
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

  Widget _sectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _card(Widget child, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

class _featureItem extends StatelessWidget {
  final String text;

  const _featureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
