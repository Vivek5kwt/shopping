import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/data/repositories/order_services.dart';
import 'package:shop/features/auth/model/order_model.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/features/screens/checkout/view/order_placed.dart';
import 'package:shop/utils/image/images.dart';
import 'package:shop/utils/loaders/full_sreen_loader.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class OrderController extends ChangeNotifier {
  final OrderServices _orderService = OrderServices();
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  List<OrderModel> get orders => _orders;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Add product to cart
  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required double totalPrice,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      TFullScreenLoader.openLoadingDialog(
        context,
        "Processing your order...",
        TImages.docerAnimation,
      );
      await _orderService.placedOrder(context, address, totalPrice);

      // Update user model with new cart
      final updatedUser = UserModel.fromJson({
        ...currentUser.toJson(),
        'cart': [],
      });

      // Notify parent provider about user update
      onUserUpdate(updatedUser);

      Get.to(() => OrderPlaced());

      // Set success message
      _successMessage = 'Order placed successfully!';

      // Show success snackbar
      if (context.mounted) {
        CustomSnackbars.showSuccess(context, "🎉 All Set!", _successMessage!);
      }

      debugPrint("✅ order has been placed");
    } catch (e) {
      // Set error message
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Show error snackbar
      if (context.mounted) {
        CustomSnackbars.showError(context, "❌ Oops!", _errorMessage!);
      }

      debugPrint("❌ Error placing order to user: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> myOrders() async {
    _setLoading(true);
    _clearMessages();
    try {
      final response = await _orderService.getMyOrders();
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
          debugPrint("📱 user side Loaded ${_orders.length} Orders");
          debugPrint("orders list: ${_orders.length}");
        } else {
          debugPrint("❌ ordersData is not a List: ${ordersData.runtimeType}");
          _errorMessage = "Invalid data format received";
        }
      } else {
        debugPrint("❌ Failed to load Orders in user side: ${response.message}");
        _errorMessage = response.message ?? "Failed to load orders";
      }
    } catch (e) {
      debugPrint("order error: ${e.toString()}");
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint("❌ Failed to load Orders in user side: $_errorMessage");
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
