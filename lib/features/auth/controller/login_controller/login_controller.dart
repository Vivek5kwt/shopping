import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/admin/features/widgets/amdin_panel_wrapper.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/utils/local_storage/storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController with ChangeNotifier {
  UserModel? _user;
  AuthStatus _status = AuthStatus.unauthenticated;
  String _message = '';
  String? _userId;
  String? _userToken;

  String? get userId => _userId;
  String? get userToken => _userToken;
  UserModel? get user => _user;
  AuthStatus get status => _status;
  String get message => _message;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _googleLoading = false;
  bool _appleLoading = false;
  bool get googleLoading => _googleLoading;
  bool get appleLoading => _appleLoading;

  void togglePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate()) return;

      _status = AuthStatus.loading;
      notifyListeners();

      final loginUser = UserModel(
        id: '',
        name: '',
        type: '',
        address: '',
        email: emailController.text,
        profilePic: '',
        password: passwordController.text,
        cart: [],
      );

      final response = await ApiService.login(loginUser);

      if (response.success && response.token != null) {
        print("User id login controller : ${response.data['_id']}");
        print("User jwt Token In login Controller : ${response.token}");

        await TLocalStorage.initialize(response.data['_id']);
        await StorageService.storeUserId(response.data['_id']);
        await StorageService.storeToken(response.token!);

        final userModel = UserModel.fromJson(response.data);
        final authUser = Provider.of<AuthProvider>(context, listen: false);

        if (authUser.user == null) {
          authUser.setUserFromModel(userModel);
        }

        await _setAuthData(response.token!, userModel);
        _message = response.message ?? '';
        _status = AuthStatus.authenticated;
        notifyListeners();

        if (userModel.type == 'admin') {
          print("Navigating to Admin Panel");
          Get.offAll(() => AdminPanelWrapper());
          CustomSnackbars.showSuccess(
            context,
            "👋 Welcome Back Admin!",
            'Access granted to admin panel.',
          );
        } else {
          print("Navigating to User Dashboard");
          Get.offAll(() => MainWrapper());
          CustomSnackbars.showSuccess(
            context,
            "👋 Welcome Back!",
            'Glad to see you again.',
          );
        }
      } else {
        _status = AuthStatus.unauthenticated;
        _message = response.message ?? 'Login failed';
        notifyListeners();
        CustomSnackbars.showError(context, 'Login Failed', _message);
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _message = 'Login failed: ${e.toString()}';
      print('Login failed: ${e.toString()}');
      CustomSnackbars.showError(context, 'Oh Snap!', _message);
      notifyListeners();
    }
  }

  /// Google Sign-In (v7.x API)
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      _googleLoading = true;
      _status = AuthStatus.loading;
      notifyListeners();

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Try initialize (may be optional on some platforms)
      try {
        await googleSignIn.initialize();
      } catch (_) {}

      // <<< CORRECT LINE: use authenticate() to get the account >>>
      final GoogleSignInAccount? account = await googleSignIn.authenticate();

      if (account == null) {
        _googleLoading = false;
        _status = AuthStatus.unauthenticated;
        _message = 'User cancelled Google sign-in';
        notifyListeners();
        CustomSnackbars.showError(context, 'Google Sign-In', 'User cancelled sign-in.');
        return;
      }

      final GoogleSignInAuthentication authentication = await account.authentication;
      final String? idToken = authentication.idToken ?? authentication.idToken;

      if (idToken == null) {
        _googleLoading = false;
        _status = AuthStatus.unauthenticated;
        _message = 'Failed to retrieve Google token';
        notifyListeners();
        CustomSnackbars.showError(context, 'Google Sign-In', 'Failed to retrieve token.');
        return;
      }

      /*final response = await ApiService.socialLogin(
        provider: 'google',
        token: idToken,
        extraData: {
          'email': account.email,
          'name': account.displayName ?? '',
          'avatar': account.photoUrl ?? '',
        },
      );

      await _handleSocialLoginResponse(response, context);*/
    } catch (e) {
      _googleLoading = false;
      _status = AuthStatus.unauthenticated;
      _message = 'Google sign-in failed: ${e.toString()}';
      print(_message);
      CustomSnackbars.showError(context, 'Google Sign-In Failed', _message);
      notifyListeners();
    }
  }

  // Apple Sign-In
  Future<void> signInWithApple(BuildContext context) async {
    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        CustomSnackbars.showError(context, 'Apple Sign-In', 'Apple Sign-In is not available on this device.');
        return;
      }

      _appleLoading = true;
      _status = AuthStatus.loading;
      notifyListeners();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        _appleLoading = false;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        CustomSnackbars.showError(context, 'Apple Sign-In', 'Failed to retrieve identity token.');
        return;
      }

      final name = [
        credential.givenName,
        credential.familyName
      ].where((s) => s != null && s!.isNotEmpty).join(' ');

    /*  final response = await ApiService.socialLogin(
        provider: 'apple',
        token: identityToken,
        extraData: {
          'email': credential.email ?? '',
          'name': name,
        },
      );

      await _handleSocialLoginResponse(response, context);*/
    } catch (e) {
      _appleLoading = false;
      _status = AuthStatus.unauthenticated;
      _message = 'Apple sign-in failed: ${e.toString()}';
      print(_message);
      CustomSnackbars.showError(context, 'Apple Sign-In Failed', _message);
      notifyListeners();
    }
  }

  Future<void> _handleSocialLoginResponse(dynamic response, BuildContext context) async {
    try {
      if (response.success && response.token != null) {
        await TLocalStorage.initialize(response.data['_id']);
        await StorageService.storeUserId(response.data['_id']);
        await StorageService.storeToken(response.token!);

        final userModel = UserModel.fromJson(response.data);
        final authUser = Provider.of<AuthProvider>(context, listen: false);

        if (authUser.user == null) {
          authUser.setUserFromModel(userModel);
        }

        await _setAuthData(response.token!, userModel);

        _message = response.message ?? 'Logged in successfully';
        _status = AuthStatus.authenticated;

        _googleLoading = false;
        _appleLoading = false;
        notifyListeners();

        if (userModel.type == 'admin') {
          Get.offAll(() => AdminPanelWrapper());
          CustomSnackbars.showSuccess(context, "👋 Welcome Back Admin!", 'Access granted to admin panel.');
        } else {
          Get.offAll(() => MainWrapper());
          CustomSnackbars.showSuccess(context, "👋 Welcome Back!", 'Glad to see you again.');
        }
      } else {
        _googleLoading = false;
        _appleLoading = false;
        _status = AuthStatus.unauthenticated;
        _message = response.message ?? 'Social login failed';
        notifyListeners();
        CustomSnackbars.showError(context, 'Login Failed', _message);
      }
    } catch (e) {
      _googleLoading = false;
      _appleLoading = false;
      _status = AuthStatus.unauthenticated;
      _message = 'Social login handling failed: ${e.toString()}';
      notifyListeners();
      CustomSnackbars.showError(context, 'Login Error', _message);
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
