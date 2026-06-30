import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/widgets/app_gradient_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: AppColors.blackColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    final focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text("verification_title".tr()),
        centerTitle: true,
        backgroundColor: const Color(0xffEEFEFF),
        surfaceTintColor: const Color(0xffEEFEFF),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(55),
                topStart: Radius.circular(55),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                  color: AppColors.blackColor.withOpacity(0.7),
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'enter_otp_msg'.tr(args: ['010123456789']),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 28),
                  Pinput(
                    focusNode: focusNode,
                    autofocus: true,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(text: "didnt_receive_code".tr()),
                        TextSpan(
                          text: 'resend_code_btn'.tr(),
                          style: const TextStyle(
                            color: Colors.black,
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
