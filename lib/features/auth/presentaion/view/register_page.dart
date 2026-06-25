import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/id_info_card.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/register_user_section.dart';
import 'package:smart_queue/features/scan_id_card/data/models/id_extract_model.dart';

class RegisterPage extends StatefulWidget {
  final IdExtractModel? idData;

  const RegisterPage({super.key, this.idData});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedCountryCode = "20";
  XFile? _pickedImage;
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final nationalIdController = TextEditingController();
  final addressController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  final userNameFocus = FocusNode();
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final nationalIdFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  IdExtractModel? _cachedIdData;

  @override
  void initState() {
    super.initState();
    _cachedIdData = widget.idData;
    if (widget.idData != null) {
      nationalIdController.text = widget.idData!.nationalId;
      nameController.text = widget.idData!.nameArabic;
      addressController.text = widget.idData!.address;
      _fillBirthDateFromNationalId(widget.idData!.nationalId);
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    nationalIdController.dispose();
    addressController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    userNameFocus.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    nationalIdFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _handleRegister() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      _handleFocusOnError();
      return;
    }

    final birthError = validateBirthDate(
      dayController.text,
      monthController.text,
      yearController.text,
    );
    if (birthError != null) {
      AppFlushbar.show(context, message: birthError, type: MessageType.error);
      return;
    }

    final phone = '+$selectedCountryCode${phoneController.text}';

    // Step 1: Send OTP to phone first
    context.read<AuthCubit>().registerSmsRequest(phone);
  }

  RegisterRequestModel _buildRegisterModel() {
    final birthDate = DateTime(
      int.parse(yearController.text),
      int.parse(monthController.text),
      int.parse(dayController.text),
    );

    return RegisterRequestModel(
      username: userNameController.text,
      email: emailController.text,
      password: passwordController.text,
      verificationToken: null,
      client: ClientRequestModel(
        nationalId: nationalIdController.text,
        phone: '+$selectedCountryCode${phoneController.text}',
        birthDate: DateFormat('yyyy-MM-dd').format(birthDate),
        address: Address(
          address: addressController.text,
          city: _extractPart(addressController.text, 0, "Unknown"),
          country: _extractPart(addressController.text, 1, "Egypt"),
        ),
        imageFile: _pickedImage,
      ),
    );
  }

  void _handleFocusOnError() {
    if (_cachedIdData == null) {
      if (nameController.text.isEmpty || nameController.text.length < 3) {
        FocusScope.of(context).requestFocus(nameFocus);
        return;
      }
      if (!RegExp(r'^\d{14}$').hasMatch(nationalIdController.text)) {
        FocusScope.of(context).requestFocus(nationalIdFocus);
        return;
      }
    }
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text)) {
      FocusScope.of(context).requestFocus(emailFocus);
    } else if (!RegExp(r'^\d{11}$').hasMatch(phoneController.text)) {
      FocusScope.of(context).requestFocus(phoneFocus);
    } else {
      FocusScope.of(context).requestFocus(passwordFocus);
    }
  }

  String _extractPart(String address, int index, String fallback) {
    final parts = address.split(',');
    return parts.length > index ? parts[index].trim() : fallback;
  }

  void _fillBirthDateFromNationalId(String nationalId) {
    if (nationalId.length != 14) return;
    final s = int.tryParse(nationalId[0]) ?? 0;
    final yy = int.tryParse(nationalId.substring(1, 3)) ?? 0;
    final mm = int.tryParse(nationalId.substring(3, 5)) ?? 0;
    final dd = int.tryParse(nationalId.substring(5, 7)) ?? 0;
    final century = (s == 3 || s == 4) ? 2000 : 1900;
    setState(() {
      dayController.text = dd.toString().padLeft(2, '0');
      monthController.text = mm.toString().padLeft(2, '0');
      yearController.text = (century + yy).toString();
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.teal,
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.teal,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        dayController.text = picked.day.toString().padLeft(2, '0');
        monthController.text = picked.month.toString().padLeft(2, '0');
        yearController.text = picked.year.toString();
      });
    }
  }

  String? validateBirthDate(String day, String month, String year) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      return "birth_date_required".tr();
    }
    final d = int.tryParse(day);
    final m = int.tryParse(month);
    final y = int.tryParse(year);
    if (d == null || m == null || y == null) return "birth_date_invalid".tr();
    if (m < 1 || m > 12) return "birth_date_month_invalid".tr();
    if (d < 1 || d > 31) return "birth_date_day_invalid".tr();
    if (DateTime(y, m, d).isAfter(DateTime.now())) {
      return "birth_date_future".tr();
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 800,
    );
    if (picked != null) setState(() => _pickedImage = picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterOtpSentSuccess) {
          // Step 2: OTP sent successfully → go to verification code screen
          // Pass the full register model so verification screen can complete registration
          AppFlushbar.show(
            context,
            message: "Verification code sent successfully!",
            type: MessageType.success,
            duration: const Duration(seconds: 2),
          );
          context.replace(
            AppRoutes.verificationCode,
            extra: {
              'phone': state.phone,
              'purpose': 'register',
              'registerModel': _buildRegisterModel(),
            },
          );
        } else if (state is RegisterSuccess) {
          // Fallback: in case register was called directly (shouldn't happen in normal flow)
          AppFlushbar.show(
            context,
            message: "registered_successfully".tr(),
            type: MessageType.success,
            duration: const Duration(seconds: 2),
          );
          context.replace(AppRoutes.login);
        } else if (state is AuthError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
            duration: const Duration(seconds: 3),
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
              colors: [AppColors.bgTop, AppColors.bgBottom],
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
                    // Header Actions Row (Back Button & Language Switcher)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Glassmorphic Back Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.tealLight.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 18,
                              color: AppColors.teal,
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),

                        // Pill Language Switcher
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.tealLight.withOpacity(0.25),
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
                            icon: const Icon(
                              Icons.language,
                              size: 16,
                              color: AppColors.teal,
                            ),
                            label: Text(
                              context.locale.languageCode == 'ar'
                                  ? 'English'
                                  : 'العربية',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Branded circular logo
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.tealLight.withOpacity(0.15),
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
                      "create_account_title".tr(),
                      style: const TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.teal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "login_subtitle".tr(),
                      style: const TextStyle(
                        fontFamily: AppStyle.fontFamily,
                        fontSize: 14,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Glassmorphic form card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.tealLight.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
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
                          if (_cachedIdData != null) ...[
                            IdInfoCard(
                              name: nameController.text,
                              nationalId: nationalIdController.text,
                              address: addressController.text,
                              birthDate:
                                  '${dayController.text}/${monthController.text}/${yearController.text}',
                            ),
                            const SizedBox(height: 24),
                          ],

                          RegisterUserSection(
                            hasIdData: _cachedIdData != null,
                            pickedImage: _pickedImage,
                            userNameController: userNameController,
                            emailController: emailController,
                            passwordController: passwordController,
                            nameController: nameController,
                            nationalIdController: nationalIdController,
                            addressController: addressController,
                            dayController: dayController,
                            monthController: monthController,
                            yearController: yearController,
                            phoneController: phoneController,
                            userNameFocus: userNameFocus,
                            emailFocus: emailFocus,
                            passwordFocus: passwordFocus,
                            nameFocus: nameFocus,
                            nationalIdFocus: nationalIdFocus,
                            onPickImage: _pickImage,
                            onPhoneChanged:
                                (phone, code) => selectedCountryCode = code,
                            onNationalIdChanged: (value) {
                              if (value.length == 14) {
                                _fillBirthDateFromNationalId(value);
                              }
                            },
                            onDateTap:
                                _cachedIdData != null ? null : _selectDate,
                            onRegister: _handleRegister,
                          ),
                        ],
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
