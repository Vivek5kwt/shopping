import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/repositories/base_api.dart';
import 'package:shop/data/services/api_response.dart';

class AddressServices {
  Future<ApiResponse> saveUserAddress(
    BuildContext context,
    String address,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${BaseApi.baseUrl}/user/save-address'),
        headers: await BaseApi.authHeaders,
        body: jsonEncode({'address': address}),
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
}
