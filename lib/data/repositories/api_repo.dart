import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/repositories/base_api.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/data/services/api_response.dart';

class ApiService {
  //  static const String baseUrl = "http://192.168.0.103:5001/api";
  // Replace with your backend URL

  // Sign Up
  static Future<ApiResponse> signUp(UserModel user) async {
    try {
      final encodedParams = json.encode(user.toJson());
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/signup'),
        headers: BaseApi.headers,
        body: encodedParams,
      );
      final url = '${BaseApi.baseUrl}/user/signup';
      debugPrint("signup url :$url");

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

  // Login
  static Future<ApiResponse> login(UserModel user) async {
    try {
      final encodedParams = json.encode(user.toJson());
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/login'),
        headers: BaseApi.headers,
        body: encodedParams,
      );
      final url = '${BaseApi.baseUrl}/user/login';
      debugPrint("login url :$url");

      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  static Future<ApiResponse> socialLogin(UserModel user) async {
    try {
      final encodedParams = json.encode(user.toJson());
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/login'),
        headers: BaseApi.headers,
        body: encodedParams,
      );
      final url = '${BaseApi.baseUrl}/user/login';
      debugPrint("login url :$url");

      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  static Future<ApiResponse> forget(String email) async {
    try {
      final encodedParams = json.encode/*user.toJson()*/;
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/login'),
        headers: BaseApi.headers,
        body: encodedParams,
      );
      final url = '${BaseApi.baseUrl}/user/login';
      debugPrint("login url :$url");

      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Check Auth
  static Future<ApiResponse> checkAuth() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApi.baseUrl}/user/check'),
        headers: await BaseApi.authHeaders,
      );

      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Get User Profile by ID
  static Future<ApiResponse> getUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApi.baseUrl}/user/getUser/$userId'),
        headers: await BaseApi.authHeaders,
      );

      final data = jsonDecode(response.body);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode == 200
            ? 'User profile retrieved successfully'
            : 'Failed to fetch user profile',
        data: data,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Update Profile
  static Future<ApiResponse> updateProfilePic({
    required BuildContext context,
    required File images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dlyajehga", "profile_images");
      String profilePic = "";

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(images.path, folder: "images"),
      );
      profilePic = response.secureUrl;

      final url = "${BaseApi.baseUrl}/user/update-profilePic";
      print("Request URL: $url");

      final headers = {...await BaseApi.authHeaders};

      final bodyData = {'profilePic': profilePic};

      final res = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(bodyData),
      );

      final data = jsonDecode(res.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future<ApiResponse> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/auth/logout'),
        headers: await BaseApi.authHeaders,
      );

      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
  // fetch All Products...

  Future<ApiResponse> getAllProducts() async {
    final response = await http.get(
      Uri.parse("${BaseApi.baseUrl}/products/getallproducts"),
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

  // Get favorite products by list of IDs
  Future<ApiResponse> getFavoriteProducts(List<String> productIds) async {
    try {
      final response = await http.post(
        Uri.parse("${BaseApi.baseUrl}/products/getfavoriteproducts"),
        headers: BaseApi.headers,
        body: jsonEncode({'productIds': productIds}),
      );

      final data = jsonDecode(response.body);

      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode == 200
            ? 'Favorite products retrieved successfully'
            : data['message'] ?? 'Failed to fetch favorite products',
        data: response.statusCode == 200 ? data['data'] : null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<ApiResponse> getCategoriesProduct(String category) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${BaseApi.baseUrl}/products/get-category-products?category=$category',
        ),
        headers: await BaseApi.authHeaders,
      );
      final data = jsonDecode(response.body);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode == 200
            ? 'Products  retrieved successfully'
            : 'Failed to fetch Products',
        data: data,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  // Search Products...

  Future<ApiResponse> searchProduct(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${BaseApi.baseUrl}/products/search/$query'),
        headers: await BaseApi.authHeaders,
      );
      final data = jsonDecode(response.body);
      return ApiResponse(
        success: response.statusCode == 200,
        message: response.statusCode == 200
            ? 'Products  retrieved successfully'
            : 'Failed to fetch Products',
        data: data,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
