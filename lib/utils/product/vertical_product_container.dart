import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/screens/details/details_screen.dart';
import 'package:shop/utils/cartButton/cart_widget.dart';
import 'package:shop/utils/favourite_icon/favourite_icon.dart';
import 'package:shop/utils/product/product_title.dart';
import 'package:shop/utils/rounded_container/rounded_container.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';
import 'package:shop/utils/shadow/shadow.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class VerticalProductContainer extends StatelessWidget {
  const VerticalProductContainer({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    double averageRating = 0;
    double totalRating = 0;
    for (int i = 0; i < productModel.rating!.length; i++) {
      totalRating += productModel.rating![i].rating;
    }
    if (totalRating != 0) {
      averageRating = totalRating / productModel.rating!.length;
    }
    final isDark = THelperFunctions.isDarkMode(context);
    //    return Consumer<ProductController>(builder: (context, controller, child) {
    // final percentage = controller.salePercentage(
    //     productModel.price, productModel.salesPrice);

    return GestureDetector(
      onTap: () => Get.to(() => DetailsScreen(product: productModel)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: isDark ? TColors.darkerGrey : TColors.white,
          boxShadow: [TShadow.verticalProductShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail sections..
            RoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: isDark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  // Images..
                  Hero(
                    tag: productModel.images[0],
                    child: Center(
                      child: RoundedImage(
                        image: productModel.images[0],
                        applyradius: true,
                        isNetworkImage: true,
                      ),
                    ),
                  ),

                  // // Sales tags..
                  // if (percentage != null)
                  //   Positioned(
                  //     top: 12,
                  //     child: RoundedContainer(
                  //       radius: TSizes.sm,
                  //       backgroundColor: TColors.secondary.withOpacity(0.8),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: TSizes.sm, vertical: TSizes.xs),
                  //       child: Text(
                  //         '$percentage%',
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .labelLarge!
                  //             .apply(color: TColors.black),
                  //       ),
                  //     ),
                  //   ),

                  // Favorite Buttons...
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FavouriteIcon(productId: productModel.id!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            // Products Details...
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitle(title: productModel.name, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 5),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Prices
                Flexible(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.sm),
                        child: Text(
                          "\$${productModel.price.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Add To Cart Button
                productModel.quantity > 0
                    ? CartWidget(product: productModel)
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            "Out of Stock",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
    //});
  }
}
