import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/date_fields_group.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/phone_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedCountryCode = "20";
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final nationalIdController = TextEditingController();
  final dayController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final nationalIdFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    passwordController.dispose();

    nameFocus.dispose();
    emailFocus.dispose();
    nationalIdFocus.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          AppFlushbar.show(
            context,
            message: "Registered successfully!",
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
                    const SizedBox(height: 10),
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Make your visit smoother with early booking",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    // ===== Name =====
                    CustomTextField(
                      label: "Name",
                      hint: "Enter your name",
                      controller: nameController,
                      icon: Icons.person,
                      focusNode: nameFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }

                        if (value.length < 3) {
                          return "Name must be at least 3 characters";
                        }

                        if (value.length > 15) {
                          return "Name must be 15 characters max";
                        }

                        return null;
                      },
                    ),

                    // ===== Email =====
                    CustomTextField(
                      label: "Email",
                      hint: "Enter your email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      focusNode: emailFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    // ===== National ID =====
                    CustomTextField(
                      label: "National ID",
                      hint: "Enter your 14-digit national ID",
                      controller: nationalIdController,
                      keyboardType: TextInputType.number,
                      icon: Icons.badge,
                      focusNode: nationalIdFocus,
                      onChanged: (value) {
                        if (value.length == 14) {
                          _fillBirthDateFromNationalId(value);
                        }
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "National ID is required";
                        }

                        if (!RegExp(r'^\d{14}$').hasMatch(value)) {
                          return "National ID must be exactly 14 digits";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(alignment: AlignmentDirectional.centerStart, child: Text("Birth Date", style: TextStyle(fontWeight: FontWeight.w500,))),
                    const SizedBox(height: 8),
                    DateFieldsGroup(
                      dayController: dayController,
                      monthController: monthController,
                      yearController: yearController,
                      onTap: _selectDate,
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: TextField(
                    //         controller: dayController,
                    //         decoration: const InputDecoration(hintText: "DD"),
                    //         keyboardType: TextInputType.number,
                    //         readOnly: true,
                    //         onTap: _selectDate,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Expanded(
                    //       child: TextField(
                    //         controller: monthController,
                    //         decoration: const InputDecoration(hintText: "MM"),
                    //         keyboardType: TextInputType.number,
                    //         readOnly: true,
                    //         onTap: _selectDate,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 8),
                    //     Expanded(
                    //       child: TextField(
                    //         controller: yearController,
                    //         decoration: const InputDecoration(hintText: "YYYY"),
                    //         keyboardType: TextInputType.number,
                    //         readOnly: true,
                    //         onTap: _selectDate,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // CustomTextField(
                    //   label: "Phone",
                    //   hint: "Enter your phone number",
                    //   controller: phoneController,
                    //   keyboardType: TextInputType.phone,
                    //   icon: Icons.phone,
                    //   focusNode: phoneFocus,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "Phone number is required";
                    //     }
                    //     if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    //       return "Phone must be 11 digits";
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 16,),
                    Align(alignment: AlignmentDirectional.centerStart, child: Text("Phone number", style: TextStyle(fontWeight: FontWeight.w500,))),
                    SizedBox(height: 8,),
                    PhoneInputField(
                      controller: phoneController,
                      onChanged: (phone, code) {
                        selectedCountryCode = code;
                      },
                    ),                    const SizedBox(height: 16,),
                    // ===== Password =====
                    CustomTextField(
                      label: "Password",
                      hint: "Enter your password",
                      controller: passwordController,
                      isPassword: true,
                      icon: Icons.lock,
                      focusNode: passwordFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        if (!RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return "Password must contain letters & numbers";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return _gradientButton("Continue", () {
                          if (_formKey.currentState!.validate()) {
                            final fullPhone = '+$selectedCountryCode${phoneController.text}';
                            final birthError = validateBirthDate(
                              dayController.text,
                              monthController.text,
                              yearController.text,
                            );

                            if (birthError != null) {
                              AppFlushbar.show(context, message: birthError, type: MessageType.error);
                              return;
                            }
                            final birthDate = DateTime(
                              int.parse(yearController.text),
                              int.parse(monthController.text),
                              int.parse(dayController.text),
                            );

                            final formattedDate = DateFormat(
                              'yyyy-MM-dd',
                            ).format(birthDate);
                            final request = RegisterRequestModel(
                              username: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              client: ClientRequestModel(
                                nationalId: nationalIdController.text,
                                phone: fullPhone,
                                birthDate: formattedDate
                              ),
                            );
                            context.read<AuthCubit>().register(request);
                          } else {
                            if (nameController.text.isEmpty ||
                                nameController.text.length < 3) {
                              FocusScope.of(context).requestFocus(nameFocus);
                            } else if (emailController.text.isEmpty ||
                                !RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(emailController.text)) {
                              FocusScope.of(context).requestFocus(emailFocus);
                            } else if (nationalIdController.text.isEmpty ||
                                !RegExp(
                                  r'^\d{14}$',
                                ).hasMatch(nationalIdController.text)) {
                              FocusScope.of(
                                context,
                              ).requestFocus(nationalIdFocus);
                            } else if (phoneController.text.isEmpty ||
                                !RegExp(
                                  r'^\d{11}$',
                                ).hasMatch(phoneController.text)) {
                              FocusScope.of(context).requestFocus(phoneFocus);
                            } else if (passwordController.text.isEmpty ||
                                passwordController.text.length < 8 ||
                                !RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)',
                                ).hasMatch(passwordController.text)) {
                              FocusScope.of(
                                context,
                              ).requestFocus(passwordFocus);
                            }
                          }
                        }, isLoading: state.isLoading);
                      },
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  context.pop(context);
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

  Widget _gradientButton(String text,
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
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
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

  void _fillBirthDateFromNationalId(String nationalId) {
    if (nationalId.length != 14) return;

    final s = int.tryParse(nationalId[0]) ?? 0;
    final yy = int.tryParse(nationalId.substring(1, 3)) ?? 0;
    final mm = int.tryParse(nationalId.substring(3, 5)) ?? 0;
    final dd = int.tryParse(nationalId.substring(5, 7)) ?? 0;

    int century = 1900;
    if (s == 3 || s == 4) century = 2000;

    final year = century + yy;

    setState(() {
      dayController.text = dd.toString().padLeft(2, '0');
      monthController.text = mm.toString().padLeft(2, '0');
      yearController.text = year.toString();
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00BFA6),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00BFA6),
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
        );
      },
    );

    if (picked != null) {
      setState(() {
        dayController.text = picked.day.toString().padLeft(2, '0');
        monthController.text = picked.month.toString().padLeft(2, '0');
        yearController.text = picked.year.toString();
      });
    }
  }
  String? validateBirthDate(
      String day, String month, String year,
      ) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) {
      return "Birth date is required";
    }

    final d = int.tryParse(day);
    final m = int.tryParse(month);
    final y = int.tryParse(year);

    if (d == null || m == null || y == null) {
      return "Invalid birth date";
    }

    if (m < 1 || m > 12) return "Invalid month";
    if (d < 1 || d > 31) return "Invalid day";

    final now = DateTime.now();
    final birthDate = DateTime(y, m, d);
    if (birthDate.isAfter(now)) return "Birth date cannot be in the future";

    return null;
  }
}

