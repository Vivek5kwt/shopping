import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/admin/features/widgets/amdin_panel_wrapper.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/view/login_screen.dart';
import 'package:shop/features/auth/view/onboarding_screen.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/utils/enums/auth_enums.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;
  bool _shouldShowOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate checking user/session data
    await Future.delayed(const Duration(seconds: 2));

    final hasCompletedOnboarding =
        await StorageService.isOnboardingComplete();

    // Remove splash screen after initialization completes
    if (mounted) {
      FlutterNativeSplash.remove();
      setState(() {
        _initialized = true;
        _shouldShowOnboarding = !hasCompletedOnboarding;
      });
    }
  }

  Future<void> _handleOnboardingComplete() async {
    await StorageService.setOnboardingComplete();

    if (!mounted) return;

    setState(() {
      _shouldShowOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const AppSplashView();
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentStatus = authProvider.status;

        switch (currentStatus) {
          case AuthStatus.authenticated:
            if (authProvider.user == null) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                ),
              );
            }

            // Navigate based on user type
            return authProvider.user!.type == "admin"
                ? const AdminPanelWrapper()
                : const MainWrapper();

          case AuthStatus.unauthenticated:
            if (_shouldShowOnboarding) {
              return OnboardingScreen(
                onComplete: _handleOnboardingComplete,
              );
            }

            return const LoginScreen();

          case AuthStatus.loading:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                ),
              ),
            );
        }
      },
    );
  }
}

/// Splash screen that mirrors the native splash artwork so that
/// there isn't a visual jump between the native and Flutter views.
class AppSplashView extends StatelessWidget {
  const AppSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7C4DFF),
      body: Stack(
        children: [
          // Decorative bottom bubble
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Logo and title
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/splash_logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  'B&W',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
