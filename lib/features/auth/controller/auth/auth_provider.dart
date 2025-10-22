import 'package:flutter/foundation.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/local_storage/storage.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  AuthStatus _status = AuthStatus.loading;
  String _message = '';

  UserModel? get user => _user;
  AuthStatus get status => _status;
  String get message => _message;
  bool get isAuthenticated => _status == AuthStatus.unauthenticated; // Fixed
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider() {
    _initializeAuth();
  }
  // CRITICAL: This must call notifyListeners()
  void setUserFromModel(UserModel user) {
    debugPrint(
      "🔄 Setting user model. Old cart count: ${_user?.cart.length}, New cart count: ${user.cart.length}",
    );
    _user = user;
    notifyListeners(); // This triggers Consumer widgets to rebuild
    debugPrint("✅ notifyListeners() called");
  }

  Future<void> _initializeAuth() async {
    try {
      final token = await StorageService.getToken();
      final userdata = await StorageService.getUser();
      final userId = await StorageService.getUserId();

      print("User Token in authprovider: $token");
      print("User data in authprovider: $userdata");
      print("User id in authprovider: $userId");

      if (token != null && userdata != null) {
        // Verify token with backend
        final response = await ApiService.checkAuth();
        print("Auth Check : ${response.success}");
        await TLocalStorage.initialize(userId!);

        if (response.success) {
          _user = UserModel.fromJson(response.data);
          print("User type in authprovider : ${_user!.type}");
          print("cart count in authprovider : ${_user!.cart.length}");
          _status = AuthStatus.authenticated;
        } else {
          // Token is invalid, clear local data
          await _clearAuthData();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _message = 'Authentication check failed: ${e.toString()}';
      print("Auth initialization error: $e");
    }

    notifyListeners(); // Moved inside try-catch, before the print that was causing error
  }

  Future<void> logout() async {
    try {
      // Clear the user-specific local storage bucket
      await TLocalStorage.instance().clearAll();

      // Clear auth data (token, user data, etc.)
      await _clearAuthData();

      _status = AuthStatus.unauthenticated;
      notifyListeners();

      print("✅ User logged out successfully");
    } catch (e) {
      print("❌ Error during logout: $e");
      _message = 'Logout failed: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> _clearAuthData() async {
    await StorageService.clearAll();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _message = '';
  }

  void clearMessage() {
    _message = '';
    notifyListeners();
  }
}
