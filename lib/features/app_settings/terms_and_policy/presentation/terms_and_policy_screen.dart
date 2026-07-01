import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

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
                    "terms_privacy_title".tr(),
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
                      _sectionTitle("intro_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "intro_desc".tr(),
                          style: TextStyle(
                            color: context.appTheme.subtleText,
                            height: 1.5,
                          ),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("user_responsibilities".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Column(
                          children: [
                            _bulletItem("resp_1".tr()),
                            Divider(color: ext.cardBorder),
                            _bulletItem("resp_2".tr()),
                            Divider(color: ext.cardBorder),
                            _bulletItem("resp_3".tr()),
                          ],
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("data_privacy_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "data_privacy_desc".tr(),
                          style: TextStyle(
                            color: context.appTheme.subtleText,
                            height: 1.5,
                          ),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("booking_usage_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "booking_usage_desc".tr(),
                          style: TextStyle(
                            color: context.appTheme.subtleText,
                            height: 1.5,
                          ),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("changes_terms_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "changes_terms_desc".tr(),
                          style: TextStyle(
                            color: context.appTheme.subtleText,
                            height: 1.5,
                          ),
                        ),
                        context,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("contact_us_title".tr(), context),
                      const SizedBox(height: 10),
                      _card(
                        ListTile(
                          leading: Icon(
                            Icons.email_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            "support@smartqueue.com",
                            style: TextStyle(
                              color: context.appTheme.subtleText,
                            ),
                          ),
                          subtitle: Text(
                            "inquiries_subtitle".tr(),
                            style: TextStyle(
                              color: context.appTheme.subtleText.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: context.appTheme.subtleText,
                          ),
                          onTap: () {},
                        ),
                        context,
                      ),

                      const SizedBox(height: 30),
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
        color: context.appTheme.subtleText,
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

class _bulletItem extends StatelessWidget {
  final String text;

  const _bulletItem(this.text);

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
