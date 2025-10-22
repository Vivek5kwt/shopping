import 'package:flutter/material.dart';
import 'package:shop/features/admin/data/services/admin_services.dart';
import 'package:shop/features/auth/model/order_model.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class AdminOrderController extends ChangeNotifier {
  final AdminServices _adminService = AdminServices();
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  List<OrderModel> get orders => _orders;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Future<void> getAllOrders() async {
    _setLoading(true);
    _clearMessages();
    try {
      final response = await _adminService.fetchAllOrders();
      debugPrint("order success: ${response.success}");

      if (response.success && response.data != null) {
        // Access the 'orders' key from response.data
        final ordersData = response.data['orders'];

        if (ordersData is List) {
          _orders = ordersData
              .map((order) => OrderModel.fromJson(order))
              .toList();

          // Sort orders by orderedAt date - newest first
          _orders.sort((a, b) {
            // Handle null dates
            if (a.orderedAt == null && b.orderedAt == null) return 0;

            // Sort descending (newest first)
            return b.orderedAt.compareTo(a.orderedAt);
          });

          debugPrint(
            "📱 admin side Loaded ${_orders.length} Orders (sorted by newest)",
          );
          debugPrint("orders list: ${_orders.length}");
        } else {
          debugPrint("❌ ordersData is not a List: ${ordersData.runtimeType}");
          _errorMessage = "Invalid data format received";
        }
      } else {
        debugPrint(
          "❌ Failed to load Orders in admin side: ${response.message}",
        );
        _errorMessage = response.message ?? "Failed to load orders";
      }
    } catch (e) {
      debugPrint("order error: ${e.toString()}");
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("❌ Failed to load Orders in admin side: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  // change order status...

  Future<void> changeOrderStatus({
    required BuildContext context,
    required OrderModel order,
    required int status,
  }) async {
    _setLoading(true);
    _clearMessages();
    try {
      final response = await _adminService.changeOrderStatus(
        context: context,
        order: order,
        status: status,
      );
      debugPrint("order status response: ${response.success}");

      if (response.success) {
        CustomSnackbars.showSuccess(
          context,
          "🎉 All Set!",
          'Order status updated!',
        );
      } else {
        debugPrint("❌ Orders status failed: ${response.message}");
        _errorMessage = response.message ?? "Failed to update orders status";
        CustomSnackbars.showError(
          context,
          "❌ Oops!",
          'Error update order status: $_errorMessage',
        );
      }
    } catch (e) {
      debugPrint("order update error: ${e.toString()}");
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("❌ Failed to update Orders status: $_errorMessage");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error update order status: $_errorMessage',
      );
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
