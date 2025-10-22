import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:shop/utils/theme/colors.dart';

class CartCounter extends StatelessWidget {
  const CartCounter({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Use Consumer to rebuild this widget when cart changes
    // return Consumer<CartController>(
    //   builder: (context, cart, child) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {},
          // onPressed: () => Get.toNamed(AppRoutes.cartScreen),
          icon: Icon(Iconsax.shopping_bag, color: color),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: TColors.black,
            ),
            child: Center(
              child: Text(
                '3',
                //cart.numOfcartItem.toString(),
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: TColors.white,
                  fontSizeFactor: 0.8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    //  },
    //);
  }
}
