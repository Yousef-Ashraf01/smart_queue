import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ext.bgGradientTop, ext.bgGradientBottom],
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
                    "help_support_header".tr(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _sectionTitle("faq_title".tr(), context),

                      const SizedBox(height: 10),

                      _card(context, [
                        _faqItem(
                          context: context,
                          question: "faq_q1".tr(),
                          answer: "faq_a1".tr(),
                        ),
                        _divider(context),
                        _faqItem(
                          context: context,
                          question: "faq_q2".tr(),
                          answer: "faq_a2".tr(),
                        ),
                        _divider(context),
                        _faqItem(
                          context: context,
                          question: "faq_q3".tr(),
                          answer: "faq_a3".tr(),
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _sectionTitle("contact_support_title".tr(), context),

                      const SizedBox(height: 10),

                      _card(context, [
                        _contactTile(
                          context: context,
                          icon: Icons.email_outlined,
                          title: "email_contact".tr(),
                          subtitle: "support@smartqueue.com",
                          onTap: () {},
                        ),
                        _divider(context),
                        _contactTile(
                          context: context,
                          icon: Icons.phone_outlined,
                          title: "phone_contact".tr(),
                          subtitle: "+20 100 000 0000",
                          onTap: () {},
                        ),
                        _divider(context),
                        _contactTile(
                          context: context,
                          icon: Icons.chat_bubble_outline,
                          title: "live_chat_contact".tr(),
                          subtitle: "live_chat_desc".tr(),
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _sectionTitle("quick_actions_title".tr(), context),

                      const SizedBox(height: 10),

                      _card(context, [
                        _actionTile(
                          context: context,
                          icon: Icons.report_problem_outlined,
                          title: "report_problem".tr(),
                          onTap: () {},
                        ),
                        _divider(context),
                        _actionTile(
                          context: context,
                          icon: Icons.feedback_outlined,
                          title: "send_feedback".tr(),
                          onTap: () {},
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

  Widget _sectionTitle(String text, BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.appTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appTheme.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 50,
      endIndent: 20,
      color: context.appTheme.cardBorder,
    );
  }

  Widget _faqItem({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      iconColor: context.appTheme.subtleText,
      collapsedIconColor: context.appTheme.subtleText,
      title: Text(
        question,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(color: context.appTheme.subtleText),
          ),
        ),
      ],
    );
  }

  Widget _contactTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.appTheme.subtleText),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: context.appTheme.subtleText),
      ),
      onTap: onTap,
    );
  }

  Widget _actionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.appTheme.subtleText),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.appTheme.subtleText,
      ),
      onTap: onTap,
    );
  }
}
