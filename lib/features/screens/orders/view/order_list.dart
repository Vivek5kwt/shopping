import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/model/order_model.dart';
import 'package:shop/features/controllers/order/order_controller.dart';
import 'package:shop/features/screens/orders/view/order_details.dart';
import 'package:shop/features/screens/orders/view/widgets/shimmer_effect.dart';
import 'package:shop/utils/responsive/responsive.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';
import 'package:shop/utils/theme/colors.dart';

// Updated OrderListScreen with shimmer and responsive design
class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<OrderController>(context, listen: false);
      controller.myOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: SafeArea(
        child: Consumer<OrderController>(
          builder: (context, controller, child) {
            // Show shimmer while loading
            if (controller.isLoading) {
              return const OrderListShimmer();
            }

            // Show empty state
            if (controller.orders.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsivePadding(
                    all: 20,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back,
                            size: responsive.iconSize(24),
                          ),
                        ),
                        SizedBox(width: responsive.spacing(20)),
                        ResponsiveText(
                          'My Orders',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ResponsiveText(
                        'No orders yet',
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              );
            }

            // Show orders list
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsivePadding(
                  all: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(
                              Icons.arrow_back,
                              size: responsive.iconSize(24),
                            ),
                          ),
                          SizedBox(width: responsive.spacing(20)),
                          ResponsiveText(
                            'My Orders',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                          ),
                        ],
                      ),
                      ResponsiveSizedBox(height: 8),
                      ResponsiveText(
                        '${controller.orders.length} orders placed',
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.spacing(20),
                    ),
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return OrderCard(order: order);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  Color _getStatusColor() {
    switch (order.status) {
      case 3:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 1:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  String _getStatus() {
    switch (order.status) {
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

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.spacing(20),
            offset: Offset(0, responsive.spacing(4)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order: order),
              ),
            );
          },
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
          child: Padding(
            padding: responsive.padding(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: responsive.spacing(70),
                      height: responsive.spacing(70),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(15),
                        ),
                      ),
                      child: Center(
                        child: RoundedImage(
                          height: responsive.spacing(50),
                          width: responsive.spacing(50),
                          image: order.products[0].images[0],
                          isNetworkImage: true,
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.spacing(16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            order.products[0].name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3142),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          ResponsiveSizedBox(height: 4),
                          ResponsiveText(
                            order.id,
                            fontSize: 13,
                            color: Colors.grey[600],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          ResponsiveSizedBox(height: 4),
                          ResponsiveText(
                            '\$${order.totalPrice.toStringAsFixed(2)}',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: TColors.tealColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ResponsiveSizedBox(height: 16),
                const Divider(height: 1),
                ResponsiveSizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            'Order Date',
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          ResponsiveSizedBox(height: 4),
                          ResponsiveText(
                            DateFormat().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                order.orderedAt,
                              ),
                            ),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3142),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: responsive.spacing(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.spacing(16),
                        vertical: responsive.spacing(8),
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(20),
                        ),
                      ),
                      child: ResponsiveText(
                        _getStatus(),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
