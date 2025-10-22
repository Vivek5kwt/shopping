import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop/features/auth/model/user.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _userId = "user_id";

  static Future<void> init() async {
    // Add any initialization logic here if needed
    // For example, you might want to check if secure storage is available
    try {
      await _storage.containsKey(key: _tokenKey);
    } catch (e) {
      print('StorageService initialization error: $e');
    }
  }

  // Store JWT token securely
  static Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Store Userid  securely
  static Future<void> storeUserId(String userId) async {
    await _storage.write(key: _userId, value: userId);
  }

  // Get Userid
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userId);
  }

  // Get JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Remove JWT token
  static Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // Store user data
  static Future<void> storeUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get user data
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Remove user data
  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Clear all data
  static Future<void> clearAll() async {
    await removeToken();
    await removeUser();
  }
}
