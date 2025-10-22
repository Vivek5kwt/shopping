import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/get_product_controller.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/admin/features/view/add_product_screen.dart';
import 'package:shop/features/admin/features/widgets/appbar.dart';
import 'package:shop/features/admin/features/widgets/quick_action_card.dart';
import 'package:shop/utils/responsive/responsive.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<GetProductController>(
        context,
        listen: false,
      );
      controller.getAllProdcuts(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Consumer<GetProductController>(
      builder: (context, controller, child) {
        debugPrint("Product list length is : ${controller.productList.length}");
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: buildAppBar('Products Management'),
          body: Padding(
            padding: responsive.padding(all: 16),
            child: Column(
              children: [
                // Quick Actions - Fixed at top
                Row(
                  children: [
                    Expanded(
                      child: buildQuickActionCard(
                        'Add Product',
                        Icons.add_box_rounded,
                        const Color(0xFF10B981),
                        () => Get.to(() => AddProductScreen()),
                      ),
                    ),
                    ResponsiveSizedBox(width: 12),
                    Expanded(
                      child: buildQuickActionCard(
                        'Bulk Import',
                        Icons.file_upload_rounded,
                        const Color(0xFF3B82F6),
                        () {},
                      ),
                    ),
                  ],
                ),
                ResponsiveSizedBox(height: 20),

                // Products List - Scrollable
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
                            'Recent Products',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Expanded(
                          child: controller.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54,
                                    ),
                                  ),
                                )
                              : controller.productList.isEmpty
                              ? Center(
                                  child: ResponsiveText(
                                    "There's is no products",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: controller.productList.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        controller.productList[index];
                                    return _buildProductItem(
                                      product,
                                      index,
                                      responsive,
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
      },
    );
  }

  Widget _buildProductItem(
    ProductModel product,
    int index,
    ResponsiveUtils responsive,
  ) {
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
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
            ),
            child: product.images.isNotEmpty && product.images[0].isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.inventory_rounded,
                          color: const Color(0xFF2563EB),
                          size: responsive.iconSize(24),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.inventory_rounded,
                    color: const Color(0xFF2563EB),
                    size: responsive.iconSize(24),
                  ),
          ),
          ResponsiveSizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  product.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                ResponsiveSizedBox(height: 4),
                Row(
                  children: [
                    ResponsiveText(
                      '\$${product.price.toStringAsFixed(2)}',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF059669),
                    ),
                    ResponsiveSizedBox(width: 12),
                    ResponsiveText(
                      'Stock: ${product.quantity.toInt()}',
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Consumer<GetProductController>(
                builder: (context, controller, child) {
                  return GestureDetector(
                    onTap: () async {
                      EasyLoading.show(status: 'Deleting product...');
                      try {
                        await controller.deleteProdcuts(context, product.id!);
                      } catch (e) {
                        print('Error deleting product: $e');
                      } finally {
                        EasyLoading.dismiss();
                      }
                    },
                    child: Container(
                      height: responsive.spacing(30),
                      width: responsive.spacing(30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(15),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Iconsax.trash,
                          size: responsive.iconSize(20),
                          color: Colors.red.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ResponsiveSizedBox(height: 10),
              Container(
                padding: responsive.padding(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.quantity > 0
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(6),
                  ),
                ),
                child: ResponsiveText(
                  product.quantity > 0 ? "Active" : "Out of Stock",
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: product.quantity > 0
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
