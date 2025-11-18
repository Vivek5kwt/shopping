import 'package:flutter/material.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'dart:math';
import 'package:shop/features/admin/data/services/admin_services.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class GetAllProduct with ChangeNotifier {
  List<ProductModel> _productsList = [];
  List<ProductModel> _randomProductsList = [];

  bool _isLoading = false;
  bool _isLoadingRandom = false;

  List<ProductModel> get productList => _productsList;
  List<ProductModel> get randomProductsList => _randomProductsList;

  bool get isLoading => _isLoading;
  bool get isLoadingRandom => _isLoadingRandom;

  // Fetch all products (for admin)
  Future<void> getAllProdcuts(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.getAllProducts();

      if (response.success && response.data is List) {
        _productsList = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        print("📱 Loaded ${_productsList.length} Products");
      } else {
        print("❌ Failed to load Products: ${response.message}");
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint(" Error while getting products controller : ${e.toString()}");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error getting product: $e',
      );
      notifyListeners();
    }
  }

  // Fetch random 4 products (for home screen)
  Future<void> getRandomProducts(BuildContext context, {int count = 4}) async {
    try {
      _isLoadingRandom = true;
      notifyListeners();

      final apiService = ApiService();
      final response = await apiService.getAllProducts();

      if (response.success && response.data is List) {
        List<ProductModel> allProducts = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();

        final List<ProductModel> tshirtProducts =
            allProducts.where((product) => _isTshirtCategory(product.category)).toList();

        // Get random products but keep the feed limited to T-shirts when possible
        final sourceList = tshirtProducts.isNotEmpty ? tshirtProducts : allProducts;
        _randomProductsList = _getRandomProductsFromList(sourceList, count);
        print(
          "🏠 Loaded ${_randomProductsList.length} Random Products for Home",
        );
      } else {
        print("❌ Failed to load Random Products: ${response.message}");
      }

      _isLoadingRandom = false;
      notifyListeners();
    } catch (e) {
      _isLoadingRandom = false;
      debugPrint("Error while getting random products: ${e.toString()}");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error getting random products: $e',
      );
      notifyListeners();
    }
  }

  // Helper method to get random products from a list
  List<ProductModel> _getRandomProductsFromList(
    List<ProductModel> products,
    int count,
  ) {
    if (products.isEmpty) return [];

    final random = Random();
    final shuffled = List<ProductModel>.from(products)..shuffle(random);

    // Return the requested count or all available products if less than count
    return shuffled.take(count).toList();
  }

  bool _isTshirtCategory(String? category) {
    if (category == null) return false;
    final normalized = category.toLowerCase();
    return normalized.contains('t-shirt') ||
        normalized.contains('tshirt') ||
        normalized.contains('tee') ||
        normalized.contains('shirt');
  }

  // Refresh random products
  Future<void> refreshRandomProducts(
    BuildContext context, {
    int count = 4,
  }) async {
    await getRandomProducts(context, count: count);
  }

  Future<void> deleteProdcuts(BuildContext context, String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      final adminService = AdminServices();
      final response = await adminService.deleteProduct(id);

      if (response.success) {
        // Remove product from both lists
        _productsList.removeWhere((product) => product.id == id);
        _randomProductsList.removeWhere((product) => product.id == id);

        print("Product deleted from local lists");
      } else {
        print("❌ Failed to delete product from local lists");
      }

      _isLoading = false;
      notifyListeners();
      CustomSnackbars.showSuccess(
        context,
        "🎉 All Set!",
        'Product deleted successfully!',
      );
    } catch (e) {
      _isLoading = false;
      debugPrint("Error while deleting product: ${e.toString()}");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error deleting product: $e',
      );
      notifyListeners();
    }
  }

  // Clear all data
  void clearData() {
    _productsList.clear();
    _randomProductsList.clear();
    notifyListeners();
  }
}
