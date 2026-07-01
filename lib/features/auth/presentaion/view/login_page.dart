import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/gradient_button.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final nationalIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final personalCubit = context.read<PersonalInfoCubit>();
          personalCubit.getProfile();
          context.go(AppRoutes.main);
        } else if (state is AuthError) {
          AppFlushbar.show(
            context,
            message: state.message.localizedApi,
            type: MessageType.error,
          );
        }
      },
      child: Scaffold(
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Pill Language Switcher
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ext.cardColor.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.isDark
                                ? ext.cardBorder
                                : AppColors.tealLight.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            if (context.locale.languageCode == 'ar') {
                              context.setLocale(const Locale('en'));
                            } else {
                              context.setLocale(const Locale('ar'));
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(
                            Icons.language,
                            size: 16,
                            color: context.isDark ? Colors.green[300]! : AppColors.teal,
                          ),
                          label: Text(
                            context.locale.languageCode == 'ar'
                                ? 'English'
                                : 'العربية',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: context.isDark ? Colors.green[300]! : AppColors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Branded circular avatar
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ext.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: context.isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.teal.withOpacity(0.06),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                        border: Border.all(
                          color: context.isDark
                              ? ext.cardBorder
                              : AppColors.tealLight.withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset(
                          AppAssets.appIcon,
                          width: 72,
                          height: 72,
                        ),
                      ),
                    ),

                    Text(
                      "welcome_back".tr(),
                      style: TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: context.isDark ? Colors.green[300]! : AppColors.teal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "login_subtitle".tr(),
                      style: TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 14,
                        color: ext.subtleText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ext.cardColor.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: context.isDark
                              ? ext.cardBorder
                              : AppColors.tealLight.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: context.isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.teal.withOpacity(0.04),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Username (National ID)
                          CustomTextField(
                            label: "national_id_label".tr(),
                            hint: "national_id_hint".tr(),
                            controller: nationalIdController,
                            keyboardType: TextInputType.number,
                            icon: Icons.badge_outlined,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(14),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "national_id_required".tr();
                              }
                              if (!RegExp(r'^\d{14}$').hasMatch(value)) {
                                return "national_id_invalid".tr();
                              }
                              return null;
                            },
                          ),

                          // Password
                          CustomTextField(
                            label: "password_label".tr(),
                            hint: "password_hint".tr(),
                            controller: passwordController,
                            isPassword: true,
                            icon: Icons.lock_outline_rounded,
                            height: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "password_required".tr();
                              }
                              if (value.length < 8) {
                                return "password_length_error".tr();
                              }
                              if (!RegExp(
                                r'^(?=.*[A-Za-z])(?=.*\d)',
                              ).hasMatch(value)) {
                                return "password_format_error".tr();
                              }
                              return null;
                            },
                          ),

                           // Forgot Password
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              onPressed: () {
                                context.push(AppRoutes.forgetPassword);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: context.isDark ? Colors.green[300]! : AppColors.teal,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "forgot_password".tr(),
                                style: const TextStyle(
                                  fontFamily: AppStyle.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Login Button
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return GradientButton(
                                text: "login".tr(),
                                isLoading: state.isLoading,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      nationalIdController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Footer Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: AppStyle.fontFamily,
                            fontSize: 14,
                            color: ext.subtleText,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: 'no_account'.tr(),
                              style: TextStyle(
                                color: ext.subtleText,
                              ),
                            ),
                            TextSpan(
                              text: 'register'.tr(),
                              style: TextStyle(
                                color: context.isDark ? Colors.green[300]! : AppColors.teal,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      context.push(AppRoutes.scanIdCard);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
