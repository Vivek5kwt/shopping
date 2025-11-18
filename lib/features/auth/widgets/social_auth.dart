import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/utils/localization/app_localizations.dart';

import '../../../utils/loaders/snackbar.dart';
import '../controller/login_controller/login_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Provider to get the LoginController instance and its state
    final controller = Provider.of<LoginController>(context);
    final loc = context.loc;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google button
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: controller.googleLoading || controller.appleLoading
                ? null
                : () => controller.signInWithGoogle(context),
            icon: controller.googleLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Image.asset("assets/images/google-icon.png", height: 30),
          ),
        ),
        const SizedBox(width: 24),
        // Apple button (show only when available on platform or show gracefully)
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: controller.appleLoading || controller.googleLoading
                ? null
                : () async {
              // Prefer platform check before calling
              final isAvailable = await SignInWithApple.isAvailable();
              if (!isAvailable) {
                CustomSnackbars.showError(
                  context,
                  loc.authSocialAppleTitle,
                  loc.authSocialAppleMessage,
                );
                return;
              }
              controller.signInWithApple(context);
            },
            icon: controller.appleLoading
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Icons.apple, color: Colors.black, size: 30),
          ),
        ),
      ],
    );
  }
}
