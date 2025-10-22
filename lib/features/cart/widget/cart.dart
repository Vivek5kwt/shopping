import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/controllers/cart_controller/cart.dart';
import 'package:shop/features/cart/widget/add_and_remove_buttons.dart';
import 'package:shop/features/cart/widget/cart_item.dart';
import 'package:shop/utils/product/product_price_text.dart';
import 'package:shop/utils/sizes/size.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.isDark,
    this.showaddremovebutton = true,
  });

  final bool isDark, showaddremovebutton;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  // void increaseQuantity(ProductModel product) {
  //   cartService.addToCart(context: context, product: product);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, controller, child) {
        // Safely get cart count
        final cartList = controller.user?.cart;
        return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (_, __) =>
              const SizedBox(height: TSizes.spaceBtwSections),
          itemCount: cartList!.length,
          itemBuilder: (context, index) {
            final cartItem = cartList[index];
            final product = ProductModel.fromJson(cartItem['product']);
            var productPrice =
                ((cartItem['product']['price']) * (cartItem['quantity']));
            var quantity = (cartItem['quantity']);
            return Column(
              children: [
                CartItems(
                  isDark: widget.isDark,
                  image: cartItem['product']['images'][0],
                  title: cartItem['product']['name'],
                ),
                if (widget.showaddremovebutton)
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                if (widget.showaddremovebutton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 70),
                          // add and reomove buttons..
                          Consumer2<CartProvider, AuthProvider>(
                            builder:
                                (context, cartProvider, authProvider, child) {
                                  return AddandRemoveButtons(
                                    isDark: widget.isDark,
                                    quantity: quantity,
                                    add: () => cartProvider.increaseQuantity(
                                      context: context,
                                      product: product,
                                      currentUser: authProvider.user!,
                                      onUserUpdate: (updatedUser) {
                                        authProvider.setUserFromModel(
                                          updatedUser,
                                        );
                                      },
                                    ),
                                    remove: () => cartProvider.decreaseQuantity(
                                      currentQuantity: quantity,
                                      context: context,
                                      product: product,
                                      currentUser: authProvider.user!,
                                      onUserUpdate: (updatedUser) {
                                        authProvider.setUserFromModel(
                                          updatedUser,
                                        );
                                      },
                                    ),
                                  );
                                },
                          ),
                        ],
                      ),
                      ProductPriceText(
                        price: (productPrice).toStringAsFixed(1),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
