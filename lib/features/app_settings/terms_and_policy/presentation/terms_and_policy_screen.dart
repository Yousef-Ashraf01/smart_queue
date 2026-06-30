import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

class TermsPolicyScreen extends StatelessWidget {
  const TermsPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
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
                  icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 28),
                  onPressed: () => context.pop(),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "terms_privacy_title".tr(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _sectionTitle("intro_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "intro_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("user_responsibilities".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Column(
                          children: [
                            _bulletItem("resp_1".tr()),
                            const Divider(),
                            _bulletItem("resp_2".tr()),
                            const Divider(),
                            _bulletItem("resp_3".tr()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("data_privacy_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "data_privacy_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("booking_usage_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "booking_usage_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("changes_terms_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "changes_terms_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("contact_us_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text("support@smartqueue.com"),
                          subtitle: Text("inquiries_subtitle".tr()),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
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
      title: Text(text),
    );
  }
}
