import 'package:flutter/material.dart';
import 'package:shop/data/repositories/rating_product.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class RatingController with ChangeNotifier {
  Future<void> updateRating(
    BuildContext context,
    ProductModel product,
    double rating,
  ) async {
    try {
      debugPrint("Product id in rating controller ${product.id}");
      final ratingProd = RatingProduct();
      await ratingProd.updateProductRating(
        context: context,
        product: product,
        rating: rating,
      );
      CustomSnackbars.showSuccess(
        context,
        "🎉 All Set!",
        'Rating added to product!',
      );
    } catch (e) {
      debugPrint(
        " Error while updating products Rating controller : ${e.toString()}",
      );
      CustomSnackbars.showError(context, "❌ Oops!", 'Error upating rating: $e');
    }
  }
}
