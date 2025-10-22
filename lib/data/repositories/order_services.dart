import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop/data/repositories/base_api.dart';
import 'package:shop/data/services/api_response.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';

class OrderServices {
  Future<ApiResponse> placedOrder(
    BuildContext context,
    String address,
    double totalPrice,
  ) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/order'),
        headers: await BaseApi.authHeaders,
        body: jsonEncode({
          'cart': authProvider.user!.cart,
          'address': address,
          'totalPrice': totalPrice,
        }),
      );

      final data = jsonDecode(response.body);
      print("USer in api : $data");
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse> getMyOrders() async {
    final response = await http.get(
      Uri.parse("${BaseApi.baseUrl}/user/getOrders/me"),
      headers: await BaseApi.authHeaders,
    );
    final data = jsonDecode(response.body);

    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Orders  retrieved successfully'
          : 'Failed to fetch Orders',
      data: data,
    );
  }
}
