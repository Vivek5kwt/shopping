import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/utils/local_storage/storage.dart';

class FavoriteController with ChangeNotifier {
  final Map<String, bool> _favorite = {};
  bool _isLoading = false;
  List<ProductModel> _favoriteProducts = [];

  Map<String, bool> get favorite => _favorite;
  bool get isLoading => _isLoading;
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  FavoriteController() {
    initFavorite();
  }

  void initFavorite() {
    try {
      final json = TLocalStorage.instance().readData("favorites");
      if (json != null) {
        final storedFavorite = jsonDecode(json) as Map<String, dynamic>;

        _favorite.clear(); // Clear existing favorites first
        _favorite.addAll(
          storedFavorite.map((key, value) => MapEntry(key, value as bool)),
        );
        print("📱 Loaded ${_favorite.length} favorites from storage");
      } else {
        _favorite.clear();
        print("📱 No favorites found in storage");
      }
      notifyListeners();
    } catch (e) {
      print("❌ Error loading favorites: $e");
      _favorite.clear();
      notifyListeners();
    }
  }

  // Call this when user logs out to clear favorites
  void clearFavorites() {
    _favorite.clear();
    _favoriteProducts.clear();
    notifyListeners();
    print("🧹 Favorites cleared");
  }

  // check is current product is Favorite...
  bool isFavorite(String productId) {
    return _favorite[productId] ?? false;
  }

  // toggle the product into favorites...
  void toggleFavorite(BuildContext context, String productId) {
    if (!_favorite.containsKey(productId)) {
      _favorite[productId] = true;
      saveFavoritetoStorage();
      notifyListeners();
      CustomSnackbars.showSuccess(
        context,
        "🎉 All Set!",
        "Product has been added to the WishList",
      );
    } else {
      _favorite.remove(productId);
      saveFavoritetoStorage();
      notifyListeners();
      CustomSnackbars.showSuccess(
        context,
        "🎉 All Set!",
        "Product has been removed from the WishList",
      );
    }
  }

  // save favorite to local storage...
  void saveFavoritetoStorage() {
    final encodedFavorite = json.encode(_favorite);
    TLocalStorage.instance().saveData("favorites", encodedFavorite);
    print("💾 Saved ${_favorite.length} favorites to storage");
  }

  // Fetch all Favorite product from firestore...
  Future<void> fetchFavorites(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (_favorite.isEmpty) {
        _favoriteProducts.clear();
        _isLoading = false;
        notifyListeners();
        print("📱 No favorites to fetch");
        return;
      }

      final apiService = ApiService();
      final response = await apiService.getFavoriteProducts(
        _favorite.keys.toList(),
      );

      if (response.success && response.data is List) {
        _favoriteProducts = (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        print("📱 Loaded ${_favoriteProducts.length} Favorite Products");
      } else {
        print("❌ Failed to load Favorite Products: ${response.message}");
        _favoriteProducts.clear();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _favoriteProducts.clear();
      debugPrint("Error while getting Favorite products: ${e.toString()}");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error getting favorite product: $e',
      );
      notifyListeners();
    }
  }
}
