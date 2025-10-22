import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/login_controller/login_controller.dart';
import 'package:shop/features/auth/view/signup_screen.dart';
import 'package:shop/features/auth/widgets/auth_footer.dart';
import 'package:shop/features/auth/widgets/auth_header.dart';
import 'package:shop/features/auth/widgets/buttons.dart';
import 'package:shop/features/auth/widgets/divider.dart';
import 'package:shop/features/auth/widgets/input_fields.dart';
import 'package:shop/features/auth/widgets/social_auth.dart';
import 'package:shop/responsive/responsiveness.dart';
import 'package:shop/utils/validators/validators.dart';

import '../../../custom_bottom_navbar.dart';
import 'forget_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Consumer<LoginController>(
          builder: (context, controller, child) {
            return Scaffold(
              // Apply same gradient background as ForgetPasswordScreen
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.2, -1.0),
                    end: Alignment(0.2, 1.0),
                    colors: <Color>[
                      Color(0xFF99C2FF),
                      Color(0xFF99C2FF),
                      Color(0xFF99C2FF),
                      Color(0xFF99C2FF),
                      Color(0xFF99C2FF),
                      Color(0xFFD0E3FE),
                      Color(0xFFB3D1FF),
                      Color(0xFFF4EDFE),
                      Color(0xFFF9F3FE),
                      Color(0xFFFDFBFE),
                      Color(0xFFFFFFFF),
                    ],
                    stops: <double>[
                      0.0,
                      0.09086468,
                      0.18172936,
                      0.27259404,
                      0.36345872,
                      0.4543234,
                      0.5456766,
                      0.63654128,
                      0.72740596,
                      0.81827064,
                      0.90913532,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveBreakpoint.isMobile(context)
                            ? 24
                            : 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // Header
                          const AuthHeader(
                            title: 'Welcome Back',
                            subtitle: 'Sign in to continue to B&W',
                          ),
                          const SizedBox(height: 40),

                          // Form
                          Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: controller.emailController,
                                  label: 'Email',
                                  hint: 'Enter your email address',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) =>
                                      TValidator.validateEmail(value),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: controller.passwordController,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  isPassword: true,
                                  isPasswordVisible:
                                  controller.obscurePassword,
                                  onTogglePassword: () =>
                                      controller.togglePassword(),
                                  validator: (value) =>
                                      TValidator.validatePassword(value),
                                ),
                                const SizedBox(height: 16),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(
                                              () => const ForgetPasswordScreen());
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize:
                                        ResponsiveBreakpoint.isMobile(
                                            context)
                                            ? 14
                                            : 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Sign In Button
                                CustomButton(
                                  text: 'Sign In',
                                  isLoading: controller.isLoading,
                                  //onPressed: () => controller.login(context),
                                  onPressed: () {
                                    Get.offAll(() => MainWrapper());
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Divider
                                const AuthDivider(text: 'or continue with'),
                                const SizedBox(height: 24),

                                // Social Auth Buttons (uses the controller for state & actions)
                                const SocialButton(),
                                const SizedBox(height: 32),

                                // Signup Link
                                AuthFooter(
                                  question: "Don't have an account?",
                                  actionText: 'Sign Up',
                                  onActionTap: () =>
                                      Get.offAll(() => const SignupScreen()),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
