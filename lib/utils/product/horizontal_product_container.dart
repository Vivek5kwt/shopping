// import 'package:ecom/common/widgets/favourite_icon/favourite_icon.dart';
// import 'package:ecom/common/widgets/product/product_price_text.dart';
// import 'package:ecom/common/widgets/product/product_title.dart';
// import 'package:ecom/common/widgets/rounded_container/rounded_container.dart';
// import 'package:ecom/common/widgets/rounded_image/rounded_images.dart';
// import 'package:ecom/common/widgets/text/brand_title_with_verified_icon.dart';
// import 'package:ecom/features/shop/controllers/product/product_controller.dart';
// import 'package:ecom/features/shop/models/product_model.dart';
// import 'package:ecom/utils/constants/colors.dart';
// import 'package:ecom/utils/constants/enums.dart';
// import 'package:ecom/utils/constants/sizes.dart';
// import 'package:ecom/utils/helpers/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';

// class HorizontalProductContainer extends StatelessWidget {
//   const HorizontalProductContainer({super.key, required this.products});
//   final ProductModel products;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = THelperFunctions.isDarkMode(context);
//     final controller = Provider.of<ProductController>(context, listen: false);
//     final percentage =
//         controller.salePercentage(products.price, products.salesPrice);

//     return Container(
//       width: 310,
//       padding: const EdgeInsets.all(1),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(TSizes.productImageRadius),
//         color: isDark ? TColors.darkerGrey : TColors.softGrey,
//         //boxShadow: [TShadow.verticalProductShadow]
//       ),
//       child: Row(
//         children: [
//           // Thumbnaill..

//           RoundedContainer(
//             height: 120,
//             padding: const EdgeInsets.all(TSizes.sm),
//             backgroundColor: isDark ? TColors.dark : TColors.white,
//             child: Stack(
//               children: [
//                 //Thumbnail image..

//                 SizedBox(
//                   height: 120,
//                   width: 120,
//                   child: RoundedImage(
//                     isNetworkImage: true,
//                     image: products.thumbnail,
//                     applyradius: true,
//                   ),
//                 ),
//                 // Sales tags..

//                 if (percentage != null)
//                   Positioned(
//                     top: 12,
//                     child: RoundedContainer(
//                       radius: TSizes.sm,
//                       backgroundColor: TColors.secondary.withOpacity(0.8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: TSizes.sm, vertical: TSizes.xs),
//                       child: Text(
//                         '$percentage%',
//                         style: Theme.of(context)
//                             .textTheme
//                             .labelLarge!
//                             .apply(color: TColors.black),
//                       ),
//                     ),
//                   ),

//                 // Favorite Buttons...
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: FavouriteIcon(
//                     productId: products.id,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Details...

//           SizedBox(
//             width: 172,
//             child: Padding(
//               padding: const EdgeInsets.only(top: TSizes.sm, left: TSizes.sm),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ProductTitle(
//                         title: products.title,
//                         smallSize: true,
//                       ),
//                       const SizedBox(
//                         height: TSizes.spaceBtwItems / 2,
//                       ),
//                       BrandTitleWithVerifiedIcon(
//                           title: products.brand?.name != null
//                               ? products.brand!.name
//                               : ''),
//                     ],
//                   ),
//                   const Spacer(),

//                   //price and add to cart button..

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Product prices..
//                       Flexible(
//                         child: Column(
//                           children: [
//                             if (products.productType ==
//                                     ProductType.single.toString() &&
//                                 products.salesPrice > 0)
//                               Padding(
//                                 padding: const EdgeInsets.only(left: TSizes.sm),
//                                 child: Text(
//                                   products.price.toString(),
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelMedium!
//                                       .apply(
//                                           decoration:
//                                               TextDecoration.lineThrough),
//                                 ),
//                               ),
//                             // Price. show sale price as main price if exist..
//                             Padding(
//                               padding: const EdgeInsets.only(left: TSizes.sm),
//                               child: ProductPriceText(
//                                 price: controller.getProductPrice(products),
//                                 isLage: false,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Add to Cart button..

//                       Container(
//                         decoration: const BoxDecoration(
//                             color: TColors.dark,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(TSizes.cardRadiusMd),
//                               bottomRight:
//                                   Radius.circular(TSizes.productImageRadius),
//                             )),
//                         child: const SizedBox(
//                           width: TSizes.iconLg * 1.2,
//                           height: TSizes.iconLg * 1.2,
//                           child: Center(
//                             child: Icon(
//                               Iconsax.add,
//                               color: TColors.white,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
