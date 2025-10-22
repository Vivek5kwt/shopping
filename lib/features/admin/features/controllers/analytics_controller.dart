import 'package:flutter/material.dart';
import 'package:shop/features/admin/data/services/admin_services.dart';
import 'package:shop/features/admin/features/models/sales.dart';

class AnalyticsController with ChangeNotifier {
  final AdminServices _adminService = AdminServices();
  bool _isLoading = false;
  List<Sales> _sales = [];
  Map<String, dynamic> _salesResults = {};
  int _totalEarnings = 0;

  bool get isLoading => _isLoading;
  List<Sales> get sales => _sales;
  int get totalEarnings => _totalEarnings;
  Map<String, dynamic> get salesResults => _salesResults;
  Future<void> getAnalytics() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _adminService.fetchAnalytics();
      debugPrint("Analytics response: ${response.success}");

      if (response.success && response.data != null) {
        // Access the nested 'earnings' object
        final earnings = response.data['earnings'] ?? {};

        _totalEarnings = (earnings['totalEarnings'] ?? 0).toInt();

        _sales = [
          Sales("Sports", (earnings['sportsEarnings'] ?? 0).toInt()),
          Sales("Clothing", (earnings['clothesEarnings'] ?? 0).toInt()),
          Sales("Electronics", (earnings['electronicsEarnings'] ?? 0).toInt()),
          Sales("Cosmetics", (earnings['cosmeticsEarnings'] ?? 0).toInt()),
          Sales("Books", (earnings['booksEarnings'] ?? 0).toInt()),
          Sales("Others", (earnings['othersEarnings'] ?? 0).toInt()),
        ];

        _salesResults = {'sales': _sales, 'totalEarnings': _totalEarnings};

        debugPrint("Sales data: $_sales");
        debugPrint("Total earnings: $_totalEarnings");
      } else {
        debugPrint("Error while getting Analytics: ${response.message}");
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("response failed while getting Analytics: ${e.toString()}");
    }
  }
}
