import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/data/repositories/address_services.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/features/screens/checkout/view/checkout_screen.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class AddressController extends ChangeNotifier {
  final AddressServices _addressService = AddressServices();
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController street = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final addressFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Add address to user
  Future<void> saveUserAddress({
    required BuildContext context,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      if (!addressFormKey.currentState!.validate()) {
        _setLoading(false);
        return;
      }

      String newAddress =
          '${name.text}, ${phoneNumber.text}, ${street.text}, ${postalCode.text}, ${city.text}, ${state.text}, ${country.text}';

      // Call API service
      final response = await _addressService.saveUserAddress(
        context,
        newAddress,
      );

      // Check if the API call was successful
      if (!response.success) {
        throw Exception(response.message);
      }

      // Extract the actual address from response data
      // Adjust this based on your actual API response structure
      final updatedAddress = response.data?['address'] ?? newAddress;

      // Update user model with new address
      final updatedUser = UserModel.fromJson({
        ...currentUser.toJson(),
        'address': updatedAddress,
      });

      // Notify parent provider about user update
      onUserUpdate(updatedUser);

      // Set success message
      _successMessage = response.message ?? 'Address added successfully!';
      Get.to(() => CheckoutScreen());
      // Show success snackbar
      if (context.mounted) {
        CustomSnackbars.showSuccess(context, "🎉 All Set!", _successMessage!);
      }

      debugPrint("✅ Address updated! New address: $updatedAddress");
      clearAllFields();
    } catch (e) {
      // Set error message
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Show error snackbar
      if (context.mounted) {
        CustomSnackbars.showError(context, "❌ Oops!", _errorMessage!);
      }

      debugPrint("❌ Error adding address to user: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  void clearAllFields() {
    name.clear();
    phoneNumber.clear();
    street.clear();
    postalCode.clear();
    city.clear();
    state.clear();
    country.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    street.dispose();
    postalCode.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    super.dispose();
  }
}
