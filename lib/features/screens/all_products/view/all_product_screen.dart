import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/controllers/products/products_controller.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/product/vertical_product_container.dart';
import 'package:shop/utils/shimmer/product_shimmer.dart';
import 'package:shop/utils/sizes/size.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  void initState() {
    super.initState();
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProductsController>(
        context,
        listen: false,
      );
      controller.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomeAppbar(title: Text("All Products"), showbackArrow: true),
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
                        'No Products Found!',
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
