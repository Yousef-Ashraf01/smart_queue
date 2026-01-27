import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';

class CenterFab extends StatelessWidget {
  const CenterFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff49FC5E), Color(0xff2B8235)],
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(AppAssets.iconAi, color: Colors.white),
        onPressed: () {
          context.push(AppRoutes.ai);
        },
      ),
    );
  }
}
