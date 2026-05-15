import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                    "Help & Support",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 25),

                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _sectionTitle("Frequently Asked Questions"),

                      const SizedBox(height: 10),

                      _card([
                        _faqItem(
                          question: "How can I book an appointment?",
                          answer:
                              "Go to the branch, select a service, and tap Book.",
                        ),
                        _divider(),
                        _faqItem(
                          question: "Can I cancel my booking?",
                          answer:
                              "Yes, you can cancel from your bookings screen.",
                        ),
                        _divider(),
                        _faqItem(
                          question: "How do I change my password?",
                          answer:
                              "Go to settings → Change Password and update it.",
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _sectionTitle("Contact Support"),

                      const SizedBox(height: 10),

                      _card([
                        _contactTile(
                          icon: Icons.email_outlined,
                          title: "Email",
                          subtitle: "support@smartqueue.com",
                          onTap: () {},
                        ),
                        _divider(),
                        _contactTile(
                          icon: Icons.phone_outlined,
                          title: "Phone",
                          subtitle: "+20 100 000 0000",
                          onTap: () {},
                        ),
                        _divider(),
                        _contactTile(
                          icon: Icons.chat_bubble_outline,
                          title: "Live Chat",
                          subtitle: "Chat with our support team",
                          onTap: () {},
                        ),
                      ]),

                      const SizedBox(height: 25),

                      _sectionTitle("Quick Actions"),

                      const SizedBox(height: 10),

                      _card([
                        _actionTile(
                          icon: Icons.report_problem_outlined,
                          title: "Report a Problem",
                          onTap: () {},
                        ),
                        _divider(),
                        _actionTile(
                          icon: Icons.feedback_outlined,
                          title: "Send Feedback",
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

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, indent: 50, endIndent: 20);
  }

  Widget _faqItem({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
