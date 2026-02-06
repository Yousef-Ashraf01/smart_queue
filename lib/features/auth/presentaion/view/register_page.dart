import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_mesh_gradient.dart';
import 'package:smart_queue/features/auth/presentaion/view/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomMeshGradient(
        colors: AppColors.meshGradient,
        blurSigma: 70,
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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

                    // يمنع كتابة الأرقام والرموز
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z\u0600-\u06FF\s]'),
                      ),
                    ],

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

                      // تأكيد إنه حروف فقط
                      if (!RegExp(
                        r'^[a-zA-Z\u0600-\u06FF\s]+$',
                      ).hasMatch(value)) {
                        return "Name must contain letters only";
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

                  // ===== Phone =====
                  CustomTextField(
                    label: "Phone",
                    hint: "Enter your phone number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    icon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required";
                      }
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return "Phone must be 11 digits";
                      }
                      return null;
                    },
                  ),

                  // ===== Password =====
                  CustomTextField(
                    label: "Password",
                    hint: "Enter your password",
                    controller: passwordController,
                    isPassword: true,
                    icon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
                        return "Password must contain letters & numbers";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  _gradientButton("Register", () {
                    if (_formKey.currentState!.validate()) {
                      // submit logic
                    }
                  }),

                  const SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }

  Widget _gradientButton(String text, VoidCallback onTap) {
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
          onPressed: onTap,
          child: Text(
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
