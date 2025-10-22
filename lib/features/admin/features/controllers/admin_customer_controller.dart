import 'package:flutter/material.dart';
import 'package:shop/features/admin/data/services/admin_services.dart';

class AdminCustomerController extends ChangeNotifier {
  final AdminServices _adminService = AdminServices();
  int _customerCount = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  int get customerCount => _customerCount;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> getAllCustomer() async {
    _setLoading(true);
    _clearMessages();
    try {
      final response = await _adminService.fetchAllCustomer();
      debugPrint("customer success: ${response.success}");

      if (response.success && response.data != null) {
        debugPrint("customer data: ${response.data}");

        // Simply get the count from the response
        _customerCount = response.data['count'] ?? 0;

        debugPrint("📱 Total customers: $_customerCount");
      } else {
        debugPrint("❌ Failed to load customer count: ${response.message}");
        _errorMessage = response.message ?? "Failed to load customer count";
      }
    } catch (e) {
      debugPrint("customer error: ${e.toString()}");
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("❌ Failed to load customer count: $_errorMessage");
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
}
