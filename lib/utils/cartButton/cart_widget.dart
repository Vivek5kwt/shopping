import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/controllers/cart_controller/cart.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProvider, authProvider, child) {
        final cartList = authProvider.user?.cart ?? [];
        Map<String, dynamic>? cartItem;

        try {
          cartItem = cartList.firstWhere(
            (item) => item['product']['_id'] == product.id,
          );
        } catch (e) {
          cartItem = null;
        }

        final currentQuantity = cartItem?['quantity'] ?? 0;

        return InkWell(
          onTap: () {
            debugPrint("add to cart in home is pressed:");
            if (authProvider.user != null) {
              cartProvider.increaseQuantity(
                context: context,
                product: product,
                currentUser: authProvider.user!,
                onUserUpdate: (updatedUser) {
                  authProvider.setUserFromModel(updatedUser);
                },
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: currentQuantity > 0 ? TColors.primary : TColors.dark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TSizes.cardRadiusMd),
                bottomRight: Radius.circular(TSizes.productImageRadius),
              ),
            ),
            child: SizedBox(
              width: TSizes.iconLg * 1.2,
              height: TSizes.iconLg * 1.2,
              child: Center(
                child: currentQuantity > 0
                    ? Text(
                        "$currentQuantity",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.apply(color: Colors.white),
                      )
                    : const Icon(Icons.add, color: TColors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
