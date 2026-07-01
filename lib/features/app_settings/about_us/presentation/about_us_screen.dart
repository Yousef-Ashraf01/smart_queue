import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
                    "about_us_header".tr(),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.apartment,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Smart Queue",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${"app_version".tr()} 1.0.0",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      _card(
                        Text(
                          "about_us_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("our_mission_title".tr()),
                      const SizedBox(height: 10),
                      _card(
                        Text(
                          "our_mission_desc".tr(),
                          style: const TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("key_features_title".tr()),
                      const SizedBox(height: 10),

                      _card(
                        Column(
                          children: [
                            _featureItem("feature_1".tr()),
                            const Divider(),
                            _featureItem("feature_2".tr()),
                            const Divider(),
                            _featureItem("feature_3".tr()),
                            const Divider(),
                            _featureItem("feature_4".tr()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("developer_title".tr()),
                      const SizedBox(height: 10),

                      _card(
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.grey),
                          title: Text(
                            "dev_team".tr(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text("dev_role".tr()),
                          trailing: const Icon(
                            Icons.verified,
                            color: Colors.green,
                          ),
                        ),
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

class _featureItem extends StatelessWidget {
  final String text;

  const _featureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(text),
    );
  }
}
