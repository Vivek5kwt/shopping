import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/admin/features/widgets/amdin_panel_wrapper.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/view/login_screen.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/loaders/full_sreen_loader.dart';
import 'package:shop/utils/image/images.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate checking user/session data
    await Future.delayed(const Duration(seconds: 2));

    // Remove splash screen after initialization completes
    if (mounted) {
      FlutterNativeSplash.remove();
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // While splash is still showing
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
          ),
        ),
      );
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
