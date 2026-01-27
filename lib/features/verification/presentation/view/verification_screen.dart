import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
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
        title: Text("Verification"),
        centerTitle: true,
        backgroundColor: Color(0xffEEFEFF),
        surfaceTintColor: Color(0xffEEFEFF),
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
                colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(55),
                topStart: Radius.circular(55),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 3),
                  color: AppColors.blackColor.withOpacity(0.7),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 100),
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

                  const Text(
                    'Please Verify Your Phone',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Enter the 6 digit code we sent by phone to\n010123456789',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  AppGradientButton(text: "Verify", onTap: () {}),
                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        const TextSpan(text: "Didn't receive the code? "),
                        TextSpan(
                          text: 'Resend Code',
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
