import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/admin_order_controller.dart';
import 'package:shop/features/admin/features/widgets/appbar.dart';
import 'package:shop/features/auth/model/order_model.dart';
import 'package:shop/utils/responsive/responsive.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AdminOrderController>(
        context,
        listen: false,
      );
      controller.getAllOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: buildAppBar('Order Management'),
      body: Padding(
        padding: responsive.padding(all: 16),
        child: Column(
          children: [
            // Filter Chips - Fixed at top
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true, responsive),
                  _buildFilterChip('Pending', false, responsive),
                  _buildFilterChip('Processing', false, responsive),
                  _buildFilterChip('Shipped', false, responsive),
                  _buildFilterChip('Delivered', false, responsive),
                ],
              ),
            ),
            ResponsiveSizedBox(height: 20),

            // Orders List - Scrollable
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsivePadding(
                      all: 20,
                      child: ResponsiveText(
                        'Recent Orders',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Expanded(
                      child: Consumer<AdminOrderController>(
                        builder: (context, controller, child) {
                          return controller.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54,
                                    ),
                                  ),
                                )
                              : controller.orders.isEmpty
                              ? Center(
                                  child: ResponsiveText(
                                    "There are no orders",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: controller.orders.length,
                                  itemBuilder: (context, index) {
                                    final order = controller.orders[index];
                                    return _buildOrderItem(order, responsive);
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    ResponsiveUtils responsive,
  ) {
    return Container(
      margin: EdgeInsets.only(right: responsive.spacing(8)),
      child: FilterChip(
        label: ResponsiveText(
          label,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? const Color(0xFF2563EB) : Colors.grey[600],
        ),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF2563EB).withOpacity(0.1),
        side: BorderSide(
          color: isSelected
              ? const Color(0xFF2563EB)
              : Colors.grey.withOpacity(0.3),
        ),
        padding: responsive.padding(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildOrderItem(OrderModel orders, ResponsiveUtils responsive) {
    Color getStatusColor(int status) {
      switch (status) {
        case 3:
          return Colors.green;
        case 2:
          return Colors.blue;
        case 1:
          return Colors.purple;
        default:
          return Colors.orange;
      }
    }

    String getStatus(int status) {
      switch (status) {
        case 3:
          return 'Delivered';
        case 2:
          return 'Shipped';
        case 1:
          return 'In Transit';
        default:
          return 'Processing';
      }
    }

    final Map<String, int> statusOptions = {
      'Processing': 0,
      'In Transit': 1,
      'Shipped': 2,
      'Delivered': 3,
    };

    return Container(
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: responsive.spacing(50),
            height: responsive.spacing(50),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            ),
            child: RoundedImage(
              image: orders.products[0].images[0],
              isNetworkImage: true,
              height: responsive.spacing(30),
              width: responsive.spacing(30),
            ),
          ),
          ResponsiveSizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: responsive.spacing(150),
                      child: ResponsiveText(
                        orders.id,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    // Dropdown menu for status
                    Container(
                      padding: responsive.padding(horizontal: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                          orders.status,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(6),
                        ),
                      ),
                      child: DropdownButton<int>(
                        value: orders.status,
                        underline: const SizedBox(),
                        isDense: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: getStatusColor(orders.status),
                          size: responsive.iconSize(20),
                        ),
                        style: TextStyle(
                          fontSize: responsive.fontSize(11),
                          fontWeight: FontWeight.w500,
                          color: getStatusColor(orders.status),
                        ),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(8),
                        ),
                        items: statusOptions.entries.map((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.value,
                            child: Container(
                              padding: responsive.padding(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: responsive.fontSize(11),
                                  fontWeight: FontWeight.w500,
                                  color: getStatusColor(entry.value),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newStatus) {
                          if (newStatus != null && newStatus != orders.status) {
                            final controller =
                                Provider.of<AdminOrderController>(
                                  context,
                                  listen: false,
                                );

                            controller
                                .changeOrderStatus(
                                  context: context,
                                  order: orders,
                                  status: newStatus,
                                )
                                .then((_) {
                                  if (controller.errorMessage == null) {
                                    controller.getAllOrders();
                                  }
                                });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                ResponsiveSizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ResponsiveText(
                      '\$${orders.totalPrice.toStringAsFixed(2)}',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                    ResponsiveText(
                      DateFormat().format(
                        DateTime.fromMillisecondsSinceEpoch(orders.orderedAt),
                      ),
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
