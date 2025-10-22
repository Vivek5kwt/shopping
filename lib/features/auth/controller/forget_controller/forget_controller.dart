import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/data/repositories/api_repo.dart';

class ForgetPasswordController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  /// Send password reset request
  Future<void> resetPassword(BuildContext context) async {
    try {
      // Validate form
      if (!formKey.currentState!.validate()) {
        return;
      }

      _isLoading = true;
      notifyListeners();

      final email = emailController.text.trim();

      // Call API
      final response = await ApiService.forget(email);

      if (response.success) {
        _message = response.message ?? 'Password reset link sent successfully.';
        CustomSnackbars.showSuccess(
          context,
          'Success',
          _message,
        );
        notifyListeners();
      } else {
        _message = response.message ?? 'Failed to send reset link.';
        CustomSnackbars.showError(
          context,
          'Error',
          _message,
        );
        notifyListeners();
      }
    } catch (e) {
      _message = 'Password reset failed: ${e.toString()}';
      CustomSnackbars.showError(context, 'Oops!', _message);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
