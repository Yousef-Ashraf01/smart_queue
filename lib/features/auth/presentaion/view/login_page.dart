import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_mesh_gradient.dart';
import '../../core/app_colors.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
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
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Make your visit smoother with early booking",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 40),

                  // Email
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

                  // Password
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

                  SizedBox(height: 10),

                  _gradientButton("Login", () {
                    if (_formKey.currentState!.validate()) {}
                  }),

                  SizedBox(height: 25),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text("Don't have an account? Register"),
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
