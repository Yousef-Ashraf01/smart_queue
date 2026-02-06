import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_mesh_gradient.dart';

class StatusBarScaffold extends StatelessWidget {
  final Widget child;
  final bool resizeToAvoidBottomInset;

  const StatusBarScaffold({
    super.key,
    required this.child,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomMeshGradient(
              colors: AppColors.meshGradient,
              blurSigma: 70,
              child: const SizedBox.expand(),
            ),
          ),

          SafeArea(
            child: child,
          ),
        ],
      ),
    );
  }
}