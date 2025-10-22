import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/data/repositories/base_api.dart';

/// Service class responsible for cart-related API calls
class CartApiService {
  /// Add a product to cart
  /// Returns the updated cart list on success
  /// Throws an exception on failure with appropriate error message
  Future<List<dynamic>> addToCart(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/add-to-cart'),
        headers: await BaseApi.authHeaders,
        body: jsonEncode({'id': productId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['cart'] != null) {
          return responseData['cart'] as List<dynamic>;
        } else {
          throw Exception('Cart data not found in response');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to add product to cart',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Add more cart-related API methods here
  Future<List<dynamic>> removeFromCart(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('${BaseApi.baseUrl}/user/remove-from-cart/$productId'),
        headers: await BaseApi.authHeaders,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['cart'] != null) {
          return responseData['cart'] as List<dynamic>;
        } else {
          throw Exception('Cart data not found in response');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to add product to cart',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Future<List<dynamic>> updateCartQuantity(String productId, int quantity) async { ... }
}
