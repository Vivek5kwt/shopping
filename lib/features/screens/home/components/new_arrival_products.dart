import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/controllers/products/get_all_product.dart';
import 'package:shop/features/screens/all_products/view/all_product_screen.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/product/vertical_product_container.dart';
import 'package:shop/utils/shimmer/product_shimmer.dart';

import 'section_title.dart';

class NewArrivalProducts extends StatefulWidget {
  const NewArrivalProducts({super.key});

  @override
  State<NewArrivalProducts> createState() => _NewArrivalProductsState();
}

class _NewArrivalProductsState extends State<NewArrivalProducts> {
  @override
  void initState() {
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<GetAllProduct>(context, listen: false);
      controller.getRandomProducts(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetAllProduct>(
      builder: (context, controller, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: SectionTitle(
                title: "New T-Shirt Drops",
                pressSeeAll: () => Get.to(() => AllProductScreen()),
              ),
            ),

            controller.isLoadingRandom
                ? VerticalProductShimmer()
                : GridLayout(
                    itemCount: controller.randomProductsList.length,
                    itemBuilder: (context, index) {
                      final product = controller.randomProductsList[index];
                      return VerticalProductContainer(productModel: product);
                    },
                  ),
          ],
        );
      },
    );
  }
}
