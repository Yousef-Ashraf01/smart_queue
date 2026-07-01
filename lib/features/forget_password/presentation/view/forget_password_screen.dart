import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/forget_password/presentation/cubit/forget_password_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final phoneController = TextEditingController();
  String countryCode = "20";

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ext.bgGradientTop, ext.bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(AppAssets.iconArrowLeft, width: 30),
                  onPressed: () => context.pop(),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'forgot_password'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'forgot_password_desc'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: ext.subtleText,
                              ),
                            ),
                            const SizedBox(height: 40),

                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0x2652D381),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF52D381),
                                        Color(0xFF2D6A4F),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'phone'.tr(),

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            PhoneInputField(
                              controller: phoneController,
                              onChanged: (phone, code) {
                                countryCode = code;
                              },
                            ),

                            const Spacer(),

                            BlocConsumer<
                              ForgetPasswordCubit,
                              ForgetPasswordState
                            >(
                              listener: (context, state) {
                                if (state is ForgetPasswordRequestSuccess) {
                                  final fullPhone =
                                      "+$countryCode${phoneController.text.trim()}";
                                  AppFlushbar.show(
                                    context,
                                    message:
                                        "verification_code_sent_success".tr(),
                                    type: MessageType.success,
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                  );
                                  Future.delayed(
                                    const Duration(milliseconds: 1500),
                                    () {
                                      context.push(
                                        AppRoutes.verificationCode,
                                        extra: fullPhone,
                                      );
                                    },
                                  );
                                } else if (state is ForgetPasswordError) {
                                  AppFlushbar.show(
                                    context,
                                    message: state.message.localizedApi,
                                    type: MessageType.error,
                                  );
                                }
                              },
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap:
                                      state is ForgetPasswordLoading
                                          ? null
                                          : () {
                                            FocusScope.of(context).unfocus();
                                            final phone =
                                                phoneController.text.trim();
                                            if (phone.isEmpty) {
                                              AppFlushbar.show(
                                                context,
                                                message:
                                                    "enter_phone_number".tr(),
                                                type: MessageType.error,
                                              );
                                              return;
                                            }
                                            final fullPhone =
                                                "+$countryCode${phoneController.text.trim()}";
                                            context
                                                .read<ForgetPasswordCubit>()
                                                .resetPasswordRequest(
                                                  fullPhone,
                                                );
                                          },
                                  child: Container(
                                    width: double.infinity,
                                    height: 56,
                                    margin: const EdgeInsets.only(
                                      bottom: 40,
                                      top: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFF63D98A),
                                          Color(0xFF1B4332),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child:
                                          state is ForgetPasswordLoading
                                              ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                              : Text(
                                                "next".tr(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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
}
