import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/data/repositories/base_api.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:http/http.dart' as http;

class RatingProduct {
  Future<void> updateProductRating({
    required BuildContext context,
    required ProductModel product,
    required double rating,
  }) async {
    debugPrint("Product id in rating api ${product.id}");
    await http.post(
      Uri.parse('${BaseApi.baseUrl}/products/rating'),
      headers: await BaseApi.authHeaders,
      body: jsonEncode({'id': product.id, 'rating': rating}),
    );
  }
}
