import 'package:flutter/material.dart';
import 'package:shop/data/repositories/cart_services.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/utils/cartButton/cart_popup.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class CartProvider extends ChangeNotifier {
  final CartApiService _apiService = CartApiService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Add product to cart
  Future<void> addToCart({
    required BuildContext context,
    required ProductModel product,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Call API service
      final updatedCart = await _apiService.addToCart(product.id!);

      // Update user model with new cart
      final updatedUser = UserModel.fromJson({
        ...currentUser.toJson(),
        'cart': updatedCart,
      });

      // Notify parent provider about user update
      onUserUpdate(updatedUser);

      // Set success message
      _successMessage = 'Product added to cart successfully!';

      // Show success snackbar
      if (context.mounted) {
        CustomSnackbars.showSuccess(context, "🎉 All Set!", _successMessage!);
      }

      debugPrint("✅ Cart updated! New count: ${updatedCart.length}");
    } catch (e) {
      // Set error message
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Show error snackbar
      if (context.mounted) {
        CustomSnackbars.showError(context, "❌ Oops!", _errorMessage!);
      }

      debugPrint("❌ Error adding to cart: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> increaseQuantity({
    required BuildContext context,
    required ProductModel product,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Call API service
      final updatedCart = await _apiService.addToCart(product.id!);

      // Update user model with new cart
      final updatedUser = UserModel.fromJson({
        ...currentUser.toJson(),
        'cart': updatedCart,
      });

      // Notify parent provider about user update
      onUserUpdate(updatedUser);

      debugPrint("✅ Cart updated! New count: ${updatedCart.length}");
    } catch (e) {
      // Set error message
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Show error snackbar
      if (context.mounted) {
        CustomSnackbars.showError(context, "❌ Oops!", _errorMessage!);
      }

      debugPrint("❌ Error adding to cart: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  /// Handle decrease quantity - shows dialog if quantity is 1
  Future<void> decreaseQuantity({
    required BuildContext context,
    required ProductModel product,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
    required int currentQuantity,
  }) async {
    // If quantity is 1, show confirmation dialog
    if (currentQuantity == 1) {
      showRemoveItemDialog(
        context: context,
        product: product,
        currentUser: currentUser,
        onUserUpdate: onUserUpdate,
      );
      return;
    }

    // Otherwise, proceed with normal decrease
    await _performDecreaseQuantity(
      context: context,
      product: product,
      currentUser: currentUser,
      onUserUpdate: onUserUpdate,
    );
  }

  /// Internal method to perform the actual decrease operation
  Future<void> _performDecreaseQuantity({
    required BuildContext context,
    required ProductModel product,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Call API service
      final updatedCart = await _apiService.removeFromCart(product.id!);

      // Update user model with new cart
      final updatedUser = UserModel.fromJson({
        ...currentUser.toJson(),
        'cart': updatedCart,
      });

      // Notify parent provider about user update
      onUserUpdate(updatedUser);

      debugPrint("✅ Cart updated! New count: ${updatedCart.length}");
    } catch (e) {
      // Set error message
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // Show error snackbar
      if (context.mounted) {
        CustomSnackbars.showError(context, "❌ Oops!", _errorMessage!);
      }

      debugPrint("❌ Error removing from cart: $_errorMessage");
    } finally {
      _setLoading(false);
    }
  }

  /// Show dialog for removing item completely
  void showRemoveItemDialog({
    required BuildContext context,
    required ProductModel product,
    required UserModel currentUser,
    required Function(UserModel) onUserUpdate,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CartItemRemovalDialog(
          itemIndex: 0, // Not needed for this use case
          onRemove: (index) async {
            // Perform the removal after confirmation
            await _performDecreaseQuantity(
              context: context,
              product: product,
              currentUser: currentUser,
              onUserUpdate: onUserUpdate,
            );

            // Show success message
            if (context.mounted) {
              CustomSnackbars.showSuccess(
                context,
                "🎉 All Set!",
                "Product removed from your cart successfully!",
              );
            }
          },
        );
      },
    );
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
