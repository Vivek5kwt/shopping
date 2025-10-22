import 'package:flutter/material.dart';
import 'package:shop/utils/product/product_title.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
    required this.isDark,
    required this.image,
    required this.title,
  });
  final String image;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedImage(
          isNetworkImage: true,
          image: image ?? '',
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: isDark ? TColors.darkerGrey : TColors.light,
        ),

        const SizedBox(width: TSizes.spaceBtwItems),

        // Title , pricie , Sizes..
        Flexible(child: ProductTitle(title: title, maxline: 1)),
        // Expanded(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Flexible(child: ProductTitle(title: title, maxline: 1)),

        //       // Attributes..
        //       Text.rich(
        //         TextSpan(
        //           children: (cartItem.selectedVariation ?? {}).entries
        //               .map(
        //                 (item) => TextSpan(
        //                   children: [
        //                     TextSpan(
        //                       text: '${item.key} ',
        //                       style: Theme.of(context).textTheme.bodySmall,
        //                     ),
        //                     TextSpan(
        //                       text: '${item.value} ',
        //                       style: Theme.of(context).textTheme.bodyLarge,
        //                     ),
        //                   ],
        //                 ),
        //               )
        //               .toList(),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
