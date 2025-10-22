import 'package:flutter/widgets.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class ProductsController with ChangeNotifier {
  bool _isLoading = false;

  List<ProductModel> _productList = [];

  bool get isLoading => _isLoading;

  List<ProductModel> get productList => _productList;

  Future<void> getAllProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiService = ApiService();

      final response = await apiService.getAllProducts();

      if (response.success && response.data is List) {
        _productList = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        print("📱 user side Loaded ${_productList.length} All Products");
      } else {
        print(
          "❌ Failed to load All Products in user side: ${response.message}",
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint(
        " Error while User getting All products controller : ${e.toString()}",
      );

      notifyListeners();
    }
  }

  Future<void> getCategoriesProducts(
    BuildContext context,
    String category,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiService = ApiService();

      final response = await apiService.getCategoriesProduct(category);

      if (response.success && response.data is List) {
        _productList = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        print("📱 user side Loaded ${_productList.length} Products");
      } else {
        print("❌ Failed to load Products in user side: ${response.message}");
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint(
        " Error while User getting products controller : ${e.toString()}",
      );
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error User getting product: $e',
      );
      notifyListeners();
    }
  }

  Future<void> searchProducts(BuildContext context, String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      final apiService = ApiService();

      final response = await apiService.searchProduct(query);

      if (response.success && response.data is List) {
        _productList = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        print("📱 search Products Loaded lenght ${_productList.length}");
      } else {
        print(
          "❌ Failed to load search Products in user side: ${response.message}",
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint(
        " Error while User search products controller : ${e.toString()}",
      );
      CustomSnackbars.showError(context, "❌ Oops!", 'Error search product: $e');
      notifyListeners();
    }
  }
}
