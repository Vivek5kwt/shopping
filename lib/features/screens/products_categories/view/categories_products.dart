import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/controllers/products/products_controller.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/product/vertical_product_container.dart';
import 'package:shop/utils/shimmer/product_shimmer.dart';
import 'package:shop/utils/sizes/size.dart';

class CategoriesProducts extends StatefulWidget {
  final String category;
  const CategoriesProducts({super.key, required this.category});

  @override
  State<CategoriesProducts> createState() => _CategoriesProductsState();
}

class _CategoriesProductsState extends State<CategoriesProducts> {
  @override
  void initState() {
    super.initState();
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProductsController>(
        context,
        listen: false,
      );
      controller.getCategoriesProducts(context, widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product grid sections..
              Consumer<ProductsController>(
                builder: (context, productController, child) {
                  if (productController.isLoading) {
                    return const VerticalProductShimmer();
                  }
                  if (productController.productList.isEmpty) {
                    return Center(
                      child: Text(
                        'No Products Found in ${widget.category} Category!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    return GridLayout(
                      itemCount: productController.productList.length,
                      itemBuilder: (context, index) {
                        final product = productController.productList[index];
                        return VerticalProductContainer(productModel: product);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
