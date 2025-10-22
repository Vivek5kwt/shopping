import 'package:flutter/material.dart';

// Admin Panel Controller
class AdminController with ChangeNotifier {
  var currentIndex = 0;

  final List<String> titles = ['Products', 'Analytics', 'Orders'];

  void changePage(int index) {
    currentIndex = index;
    notifyListeners();
  }

  String get currentTitle => titles[currentIndex];
}
