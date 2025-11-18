import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  bool _isFetchingLocation = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isFetchingLocation => _isFetchingLocation;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Use the user's current location to autofill the address fields.
  Future<void> useCurrentLocation(BuildContext context) async {
    if (_isFetchingLocation) return;
    _setFetchingLocation(true);
    _clearMessages();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable GPS.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Enable them from Settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('Unable to detect your location. Please try again.');
      }

      final place = placemarks.first;
      final streetParts = [
        place.street,
        place.subLocality,
      ].whereType<String>().where((value) => value.trim().isNotEmpty).toList();

      street.text = streetParts.join(', ');
      city.text = (place.locality?.isNotEmpty ?? false)
          ? place.locality!
          : (place.subAdministrativeArea ?? '');
      state.text = place.administrativeArea ?? '';
      postalCode.text = place.postalCode ?? '';
      country.text = place.country ?? '';
      notifyListeners();

      if (context.mounted) {
        CustomSnackbars.showSuccess(
          context,
          'Location detected',
          'We filled your address using your current location.',
        );
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      if (context.mounted) {
        CustomSnackbars.showError(context, 'Location error', _errorMessage!);
      }
    } finally {
      _setFetchingLocation(false);
    }
  }

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

  void _setFetchingLocation(bool value) {
    _isFetchingLocation = value;
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
