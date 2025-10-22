import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/admin/features/widgets/amdin_panel_wrapper.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/utils/local_storage/storage.dart';

class SignupController with ChangeNotifier {
  UserModel? _user;
  AuthStatus _status = AuthStatus.unauthenticated;
  String _message = '';
  bool _isAdmin = false; // Default to user type

  UserModel? get user => _user;
  AuthStatus get status => _status;
  String get message => _message;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAdmin => _isAdmin;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleAdminMode() {
    _isAdmin = !_isAdmin;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    try {
      // Validate form
      if (!formKey.currentState!.validate()) {
        return;
      }

      _status = AuthStatus.loading;
      notifyListeners();

      print("User Type in signup controller: ${_isAdmin ? 'admin' : 'user'}");

      /// Instead of hitting the API, create dummy data
      await Future.delayed(const Duration(seconds: 1)); // simulate loading

      // Dummy token and user ID
      final dummyToken = "dummy_jwt_token_123456";
      final dummyUserId = "user_${DateTime.now().millisecondsSinceEpoch}";

      // Create a dummy user model
      final newUser = UserModel(
        id: dummyUserId,
        address: "123 Demo Street",
        name: nameController.text,
        type: _isAdmin ? 'admin' : 'user',
        email: emailController.text,
        profilePic: "",
        password: passwordController.text,
        cart: [],
      );

      // Simulate saving locally
      await StorageService.storeUserId(dummyUserId);
      await TLocalStorage.initialize(dummyUserId);

      final authUser = Provider.of<AuthProvider>(context, listen: false);
      if (authUser.user == null) {
        authUser.setUserFromModel(newUser);
      }

      // Set auth data locally
      await _setAuthData(dummyToken, newUser);

      _message = "Dummy signup successful!";
      _status = AuthStatus.authenticated;
      notifyListeners();

      // Navigate based on user type
      if (newUser.type == 'admin') {
        print("Navigating to Admin Panel (dummy)");
        Get.offAll(() => AdminPanelWrapper());
        CustomSnackbars.showSuccess(
          context,
          "🎉 All Set!",
          "Your admin account is ready to roll (dummy).",
        );
      } else {
        print("Navigating to User Dashboard (dummy)");
        Get.offAll(() => MainWrapper());
        CustomSnackbars.showSuccess(
          context,
          "🎉 All Set!",
          "Your account is ready to roll (dummy).",
        );
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _message = 'Sign up failed: ${e.toString()}';
      CustomSnackbars.showError(context, "❌ Oops!", _message);
      print(_message);
      notifyListeners();
    }
  }

  Future<void> _setAuthData(String token, UserModel user) async {
    await StorageService.storeToken(token);
    await StorageService.storeUser(user);
    _user = user;
    _status = AuthStatus.authenticated;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
