// Analytics Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/admin_customer_controller.dart';
import 'package:shop/features/admin/features/controllers/admin_order_controller.dart';
import 'package:shop/features/admin/features/controllers/analytics_controller.dart';
import 'package:shop/features/admin/features/controllers/get_product_controller.dart';
import 'package:shop/features/admin/features/widgets/appbar.dart';
import 'package:shop/features/admin/features/widgets/sales_charts.dart';
import 'package:shop/utils/responsive/responsive.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Load analytics when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AdminCustomerController>(
        context,
        listen: false,
      );
      controller.getAllCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: buildAppBar('Analytics Dashboard'),
      body: SingleChildScrollView(
        padding: responsive.padding(all: 16),
        child: Column(
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: Consumer<AnalyticsController>(
                    builder: (context, analyticsController, child) {
                      return _buildStatCard(
                        responsive,
                        'Revenue',
                        analyticsController.isLoading
                            ? 'Loading...'
                            : '\$${analyticsController.totalEarnings.toStringAsFixed(2)}',
                        Icons.trending_up,
                        const Color(0xFF10B981),
                      );
                    },
                  ),
                ),
                SizedBox(width: responsive.spacing(12)),
                Expanded(
                  child: Consumer<AdminOrderController>(
                    builder: (context, orderController, child) {
                      return _buildStatCard(
                        responsive,
                        'Orders',
                        orderController.isLoading
                            ? 'Loading...'
                            : '${orderController.orders.length}',
                        Icons.shopping_bag,
                        const Color(0xFF3B82F6),
                      );
                    },
                  ),
                ),
              ],
            ),
            ResponsiveSizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Consumer<GetProductController>(
                    builder: (context, productController, child) {
                      return _buildStatCard(
                        responsive,
                        'Products',
                        productController.isLoading
                            ? 'Loading...'
                            : '${productController.productList.length}',
                        Icons.inventory_2,
                        const Color(0xFF8B5CF6),
                      );
                    },
                  ),
                ),
                SizedBox(width: responsive.spacing(12)),
                Expanded(
                  child: Consumer<AdminCustomerController>(
                    builder: (context, customerController, child) {
                      return _buildStatCard(
                        responsive,
                        'Customers',
                        customerController.isLoading
                            ? 'Loading...'
                            : '${customerController.customerCount}',
                        Icons.people,
                        const Color(0xFFF59E0B),
                      );
                    },
                  ),
                ),
              ],
            ),
            ResponsiveSizedBox(height: 20),

            // Chart Placeholder
            Container(
              height: responsive.heightPercent(52),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: responsive.spacing(10),
                    offset: Offset(0, responsive.spacing(2)),
                  ),
                ],
              ),
              child: SalesChart(),
            ),
            ResponsiveSizedBox(height: 20),

            // Recent Activity
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: responsive.spacing(10),
                    offset: Offset(0, responsive.spacing(2)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsivePadding(
                    all: 20,
                    child: ResponsiveText(
                      'Recent Activity',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  ...List.generate(
                    4,
                    (index) => _buildActivityItem(responsive, index),
                  ),
                  ResponsiveSizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    ResponsiveUtils responsive,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: responsive.iconSize(24)),
              Container(
                padding: EdgeInsets.all(responsive.spacing(4)),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(4),
                  ),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: const Color(0xFF059669),
                  size: responsive.iconSize(12),
                ),
              ),
            ],
          ),
          ResponsiveSizedBox(height: 12),
          ResponsiveText(
            value,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ResponsiveSizedBox(height: 4),
          ResponsiveText(title, fontSize: 14, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ResponsiveUtils responsive, int index) {
    final activities = [
      {
        'text': 'New order #1234 received',
        'time': '2 min ago',
        'icon': Icons.shopping_cart,
      },
      {
        'text': 'Product "iPhone 14" updated',
        'time': '15 min ago',
        'icon': Icons.edit,
      },
      {
        'text': 'Customer John Doe registered',
        'time': '1 hour ago',
        'icon': Icons.person_add,
      },
      {
        'text': 'Payment \$299 received',
        'time': '2 hours ago',
        'icon': Icons.payment,
      },
    ];

    final activity = activities[index];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(20),
        vertical: responsive.spacing(12),
      ),
      child: Row(
        children: [
          Container(
            width: responsive.spacing(36),
            height: responsive.spacing(36),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: const Color(0xFF2563EB),
              size: responsive.iconSize(18),
            ),
          ),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  activity['text'] as String,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox(height: 2),
                ResponsiveText(
                  activity['time'] as String,
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
