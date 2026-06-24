import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/forget_password/presentation/cubit/forget_password_cubit.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String phone;
  final String purpose;

  /// Only used when purpose == 'register': holds all register data
  final RegisterRequestModel? registerModel;

  const VerificationCodeScreen({
    super.key,
    required this.phone,
    this.purpose = 'reset_password',
    this.registerModel,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Used to auto-focus the first OTP field when the screen opens.
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  Timer? _timer;

  // 5 minutes expiry (5 * 60 = 300 seconds)
  static const int _otpDuration = 5 * 60;
  int _secondsRemaining = _otpDuration;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Auto-focus the first OTP field right after the first frame is drawn.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  String get _timerDisplay {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onVerifyPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    final code = controllers.map((c) => c.text.trim()).join();
    if (code.length < 6) {
      AppFlushbar.show(
        context,
        message: "Please enter the complete 6-digit verification code",
        type: MessageType.error,
      );
      return;
    }

    if (widget.purpose == 'register') {
      // Step 3: verify SMS code → get verification_token → then register
      context.read<ForgetPasswordCubit>().verifyRegisterSmsCode(
        phone: widget.phone,
        code: code,
      );
    } else {
      context.read<ForgetPasswordCubit>().verifySmsCode(
        phone: widget.phone,
        code: code,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordRequestSuccess ||
            state is RegisterSmsRequestSuccess) {
          AppFlushbar.show(
            context,
            message: "Verification code resent successfully!",
            type: MessageType.success,
          );
        } else if (state is ForgetPasswordVerifySuccess) {
          context.push(AppRoutes.createNewPassword, extra: state.sessionToken);
        } else if (state is RegisterVerifySuccess) {
          // Step 4: SMS verified → now do the actual registration with verification_token
          if (widget.registerModel != null) {
            final modelWithToken = RegisterRequestModel(
              username: widget.registerModel!.username,
              email: widget.registerModel!.email,
              password: widget.registerModel!.password,
              verificationToken: state.verificationToken,
              client: widget.registerModel!.client,
            );
            context.read<AuthCubit>().register(modelWithToken);
          } else {
            // Fallback: go to login if no register model
            AppFlushbar.show(
              context,
              message: "Account verified successfully! Please login.",
              type: MessageType.success,
              duration: const Duration(seconds: 2),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) context.go(AppRoutes.login);
            });
          }
        } else if (state is ForgetPasswordError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      builder: (context, fpState) {
        if (widget.purpose == 'register') {
          // For register: also listen to AuthCubit for the final register call
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, authState) {
              if (authState is RegisterSuccess) {
                AppFlushbar.show(
                  context,
                  message: "registered_successfully".tr(),
                  type: MessageType.success,
                  duration: const Duration(seconds: 2),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) context.go(AppRoutes.login);
                });
              } else if (authState is AuthError) {
                AppFlushbar.show(
                  context,
                  message: authState.message,
                  type: MessageType.error,
                );
              }
            },
            builder: (context, authState) {
              final isLoading =
                  fpState is ForgetPasswordLoading || authState is AuthLoading;
              return _buildScaffold(context, isLoading);
            },
          );
        }
        // For reset_password purpose
        return _buildScaffold(context, fpState is ForgetPasswordLoading);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, bool isLoading) {
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    AppAssets.iconArrowLeft,
                    width: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Verification Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
                            const SizedBox(height: 15),
                            const Text(
                              'We sent otp verification to your phone\nthis code will expired in',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF8E8E93),
                              ),
                            ),
                            const SizedBox(height: 8),

                            Text(
                              _timerDisplay,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8E8E93),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 40),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                6,
                                (index) => _buildOTPField(index),
                              ),
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(
                                    color: Color(0xFF8E8E93),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _secondsRemaining == 0
                                      ? () {
                                          setState(() {
                                            _secondsRemaining = _otpDuration;
                                            _startTimer();
                                          });
                                          if (widget.purpose == 'register') {
                                            context
                                                .read<ForgetPasswordCubit>()
                                                .registerSmsRequest(
                                                  widget.phone,
                                                );
                                          } else {
                                            context
                                                .read<ForgetPasswordCubit>()
                                                .resetPasswordRequest(
                                                  widget.phone,
                                                );
                                          }
                                        }
                                      : null,
                                  child: Text(
                                    "Resend Code",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _secondsRemaining == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => _onVerifyPressed(context),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                margin: const EdgeInsets.only(
                                  bottom: 40,
                                  top: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: isLoading
                                        ? [
                                            Colors.grey,
                                            Colors.grey.shade700,
                                          ]
                                        : const [
                                            Color(0xFF63D98A),
                                            Color(0xFF1B4332),
                                          ],
                                  ),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Send",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
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

  Widget _buildOTPField(int index) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          autofocus: index == 0,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: AppColors.greenStart,
          maxLength: 1,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }
}
