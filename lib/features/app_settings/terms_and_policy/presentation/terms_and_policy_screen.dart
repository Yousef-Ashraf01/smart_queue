import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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

                const Center(
                  child: Text(
                    "Terms & Privacy Policy",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _sectionTitle("Introduction"),
                      const SizedBox(height: 10),
                      _card(
                        const Text(
                          "By using Smart Queue, you agree to comply with and be bound by the following terms and conditions.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("User Responsibilities"),
                      const SizedBox(height: 10),
                      _card(
                        Column(
                          children: const [
                            _bulletItem("Provide accurate information"),
                            Divider(),
                            _bulletItem("Do not misuse the app"),
                            Divider(),
                            _bulletItem("Respect other users"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Data & Privacy"),
                      const SizedBox(height: 10),
                      _card(
                        const Text(
                          "We collect limited personal data to improve user experience. Your data is stored securely and is not shared with third parties without consent.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Booking & Usage"),
                      const SizedBox(height: 10),
                      _card(
                        const Text(
                          "Users can book appointments through the app. Availability depends on branch schedules and services offered.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Changes to Terms"),
                      const SizedBox(height: 10),
                      _card(
                        const Text(
                          "We may update these terms at any time. Continued use of the app means you accept the updated terms.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Contact Us"),
                      const SizedBox(height: 10),
                      _card(
                        ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: const Text("support@smartqueue.com"),
                          subtitle: const Text("For any inquiries"),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
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
