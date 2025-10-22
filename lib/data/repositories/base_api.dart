import 'package:shop/data/services/storage_services.dart';

class BaseApi {
  // static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String baseUrl = '';

  static const String iosbaseUrl = "http://localhost:5001/api";
  static const String realdevice = "http://192.168.0.103:5001/api";

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  static Future<Map<String, String>> get authHeaders async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
