// Main Admin Panel Wrapper
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/bottom_navbar.dart';
import 'package:shop/features/admin/features/view/analytics_screen.dart';
import 'package:shop/features/admin/features/view/order_managements.dart';
import 'package:shop/features/admin/features/view/products_management.dart';

class AdminPanelWrapper extends StatelessWidget {
  const AdminPanelWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Main content area
          Consumer<AdminController>(
            builder: (context, controller, child) {
              return IndexedStack(
                index: controller.currentIndex,
                children: const [
                  ProductManagementScreen(),
                  AnalyticsScreen(),
                  OrderManagementScreen(),
                ],
              );
            },
          ),
          // Persistent admin bottom navigation
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AdminBottomNavBar(),
          ),
        ],
      ),
    );
  }
}

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.inventory_2_rounded,
            label: 'Products',
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.analytics_rounded,
            label: 'Analytics',
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.shopping_cart_checkout_rounded,
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    return Consumer<AdminController>(
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () => controller.changePage(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: controller.currentIndex == index
                  ? const Color(0xFF2563EB).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: controller.currentIndex == index
                      ? const Color(0xFF2563EB)
                      : Colors.grey,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: controller.currentIndex == index
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: controller.currentIndex == index
                        ? const Color(0xFF2563EB)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
