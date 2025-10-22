import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:shop/data/services/api_response.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shop/features/auth/model/order_model.dart';

class AdminServices {
  // static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String baseUrl = "https://flourish-server.vercel.app/api";
  static const String iosbaseUrl = "http://localhost:5001/api";
  static const String realdevice = "http://192.168.0.103:5001/api";

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> addProducts({
    required BuildContext context,
    required String name,
    required String descriptions,
    required double price,
    required int quantity,
    required String category,
    required List<File> images,
  }) async {
    final cloudinary = CloudinaryPublic("dlyajehga", "product_images");
    List<String> imagesUrls = [];

    for (int i = 0; i < images.length; i++) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(images[i].path, folder: name),
      );
      imagesUrls.add(response.secureUrl);
    }
    ProductModel products = ProductModel(
      name: name,
      descriptions: descriptions,
      price: price,
      quantity: quantity,
      images: imagesUrls,
      category: category,
    );

    await http.post(
      Uri.parse("$baseUrl/admin/add-products"),
      headers: await _authHeaders,
      body: json.encode(products.toJson()),
    );
  }

  // fetch All Products...

  Future<ApiResponse> fetchAllProducts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin/get-products"),
      headers: await _authHeaders,
    );
    final data = jsonDecode(response.body);
    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Products  retrieved successfully'
          : 'Failed to fetch Products',
      data: data,
    );
  }

  // fetch all orders...

  Future<ApiResponse> fetchAllOrders() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin/get-orders"),
      headers: await _authHeaders,
    );
    final data = jsonDecode(response.body);

    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Products  retrieved successfully'
          : 'Failed to fetch Products',
      data: data,
    );
  }

  Future<ApiResponse> fetchAllCustomer() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin/customer"),
      headers: await _authHeaders,
    );
    final data = jsonDecode(response.body);

    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'customers  retrieved successfully'
          : 'Failed to fetch customers',
      data: data,
    );
  }

  // change order status...
  Future<ApiResponse> changeOrderStatus({
    required BuildContext context,
    required OrderModel order,
    required int status,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/change-order-status"),
      headers: await _authHeaders,
      body: jsonEncode({"id": order.id, "status": status}),
    );
    final data = jsonDecode(response.body);
    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Products  retrieved successfully'
          : 'Failed to fetch Products',
      data: data,
    );
  }

  // Delete Product By Id...
  Future<ApiResponse> deleteProduct(String id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/admin/delete-products"),
      headers: await _authHeaders,
      body: jsonEncode({"id": id}),
    );
    final data = jsonDecode(response.body);
    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Products  retrieved successfully'
          : 'Failed to fetch Products',
      data: data,
    );
  }

  // fetch analytics...

  Future<ApiResponse> fetchAnalytics() async {
    final response = await http.get(
      Uri.parse("$baseUrl/admin/analytics"),
      headers: await _authHeaders,
    );
    final data = jsonDecode(response.body);

    return ApiResponse(
      success: response.statusCode == 200,
      message: response.statusCode == 200
          ? 'Products  retrieved successfully'
          : 'Failed to fetch Products',
      data: data,
    );
  }
}
