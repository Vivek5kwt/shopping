import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/widgets/buttons.dart';
import 'package:shop/features/auth/widgets/divider.dart';
import 'package:shop/features/auth/widgets/input_fields.dart';
import 'package:shop/features/auth/widgets/auth_footer.dart';
import 'package:shop/features/auth/widgets/auth_header.dart';
import 'package:shop/features/auth/widgets/social_auth.dart';
import 'package:shop/features/auth/view/login_screen.dart';
import 'package:shop/responsive/responsiveness.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/validators/validators.dart';

import '../controller/forget_controller/forget_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final loc = context.loc;
        return ChangeNotifierProvider(
          create: (_) => ForgetPasswordController(),
          child: Consumer<ForgetPasswordController>(
            builder: (context, controller, child) {
              return Scaffold(
                // full-screen container with sampled gradient from your login image
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      // slightly diagonal to better match the source image
                      begin: Alignment(-0.2, -1.0),
                      end: Alignment(0.2, 1.0),
                      colors: <Color>[
                        Color(0xFF99C2FF), // top subtle gray/blue
                        Color(0xFF99C2FF), // light blue
                        Color(0xFF99C2FF), // pale blue
                        Color(0xFF99C2FF), // very light blue
                        Color(0xFF99C2FF), // a bit deeper sky blue
                        Color(0xFFD0E3FE), // light blue
                        Color(0xFFB3D1FF),
                        Color(0xFFF4EDFE), // soft pink-lavender
                        Color(0xFFF9F3FE), // near-white pink-lavender
                        Color(0xFFFDFBFE), // almost white
                        Color(0xFFFFFFFF), // white near bottom
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
                            const SizedBox(height: 10),

                            // Back Button
                            IconButton(
                              onPressed: () =>
                                  Get.offAll(() => const LoginScreen()),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87, // App theme color
                                size: 28,
                              ),
                              tooltip: loc.authBackToSignIn,
                            ),

                            const SizedBox(height: 10),

                            // Header
                            AuthHeader(
                              title: loc.authForgotTitle,
                              subtitle: loc.authForgotSubtitle,
                            ),
                            const SizedBox(height: 40),

                            // Form
                            Form(
                              key: controller.formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    controller: controller.emailController,
                                    label: loc.authEmailLabel,
                                    hint: loc.authEmailHint,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => TValidator.validateEmail(value),
                                  ),
                                  const SizedBox(height: 20),

                                  // Reset Button
                                  CustomButton(
                                    text: loc.authForgotButton,
                                    isLoading: controller.isLoading,
                                    onPressed: () => controller.resetPassword(context),
                                  ),
                                  const SizedBox(height: 24),

                                  AuthFooter(
                                    question: loc.authForgotFooterQuestion,
                                    actionText: loc.authFooterSignIn,
                                    onActionTap: () => Get.offAll(() => const LoginScreen()),
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
          ),
        );
      },
    );
  }
}
