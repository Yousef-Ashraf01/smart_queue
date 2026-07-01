import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_gradient_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: ext.cardColor,
        border: Border.all(color: ext.cardBorder),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text("verification_title".tr()),
        centerTitle: true,
        backgroundColor: ext.bgGradientTop,
        surfaceTintColor: ext.bgGradientTop,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ext.bgGradientTop, ext.bgGradientBottom],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: ext.cardColor,
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(55),
                topStart: Radius.circular(55),
              ),
              border: Border.all(color: ext.cardBorder),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                  color: AppColors.blackColor.withOpacity(
                    context.isDark ? 0.25 : 0.12,
                  ),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.mark_email_read_outlined,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'verify_phone_title'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'enter_otp_msg'.tr(args: ['010123456789']),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: ext.subtleText, fontSize: 14),
                  ),

                  const SizedBox(height: 28),
                  Pinput(
                    focusNode: focusNode,
                    autofocus: true,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ext.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                    ),
                    onCompleted: (pin) {
                      print('OTP Entered: $pin');
                    },
                  ),
                  const SizedBox(height: 30),
                  AppGradientButton(text: "verify_btn".tr(), onTap: () {}),
                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: ext.subtleText),
                      children: [
                        TextSpan(text: "didnt_receive_code".tr()),
                        TextSpan(
                          text: 'resend_code_btn'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
