import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final personalCubit = context.read<PersonalInfoCubit>();
          personalCubit.getProfile();
          context.go(AppRoutes.main);
        } else if (state is AuthError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        onPressed: () {
                          if (context.locale.languageCode == 'ar') {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('ar'));
                          }
                        },
                        icon: const Icon(Icons.language, size: 20, color: Color.fromARGB(255, 11, 58, 30)),
                        label: Text(
                          context.locale.languageCode == 'ar' ? 'English' : 'العربية',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 11, 58, 30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "welcome_back".tr(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "login_subtitle".tr(),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    // Username
                    CustomTextField(
                      label: "national_id_label".tr(),
                      hint: "national_id_hint".tr(),
                      controller: nationalIdController,
                      keyboardType: TextInputType.number,
                      icon: Icons.badge,
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

                    CustomTextField(
                      label: "password_label".tr(),
                      hint: "password_hint".tr(),
                      controller: passwordController,
                      isPassword: true,
                      icon: Icons.lock,
                      height: 0,
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
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {
                          context.push(AppRoutes.forgetPassword);
                        },
                        child: Text(
                          "forgot_password".tr(),
                          style: const TextStyle(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return _gradientButton("login".tr(), () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              nationalIdController.text,
                              passwordController.text,
                            );
                          }
                        }, isLoading: state.isLoading);
                      },
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'no_account'.tr(),
                              style: TextStyle(color: AppColors.greyColor),
                            ),
                            TextSpan(
                              text: 'register'.tr(),
                              style: const TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
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

  Widget _gradientButton(
    String text,
    VoidCallback onTap, {
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 118, 226, 136),
              Color.fromARGB(255, 11, 58, 30),
            ],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: isLoading ? null : onTap,
          child:
              isLoading
                  ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                  : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
