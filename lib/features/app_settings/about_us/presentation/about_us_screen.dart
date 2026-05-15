import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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

                const Center(
                  child: Text(
                    "About Us",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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

                      const Center(
                        child: Column(
                          children: [
                            Text(
                              "Smart Queue",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Version 1.0.0",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      _card(
                        const Text(
                          "Smart Queue is an application designed to simplify booking and managing appointments in branches. "
                          "It helps users reduce waiting time, organize visits, and improve the overall experience.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Our Mission"),
                      const SizedBox(height: 10),
                      _card(
                        const Text(
                          "To provide a seamless and efficient queue management system that saves time and enhances user experience.",
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Key Features"),
                      const SizedBox(height: 10),

                      _card(
                        Column(
                          children: const [
                            _featureItem("Easy booking system"),
                            Divider(),
                            _featureItem("Real-time updates"),
                            Divider(),
                            _featureItem("Branch & service selection"),
                            Divider(),
                            _featureItem("User-friendly interface"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle("Developer"),
                      const SizedBox(height: 10),

                      _card(
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.grey),
                          title: const Text(
                            "Smart Queue Team",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: const Text("Mobile App Development"),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
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
