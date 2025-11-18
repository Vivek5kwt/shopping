import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/cart/widget/cart.dart';
import 'package:shop/features/screens/checkout/view/checkout_screen.dart';
import 'package:shop/utils/image/images.dart';
import 'package:shop/utils/loaders/animation_loader.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/helper.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final mainController = context.read<MainController>();

    return SafeArea(
      child: Consumer<AuthProvider>(
        builder: (context, controller, child) {
          final navigator = Navigator.of(context);
          final canPop = navigator.canPop();
          final emptyWidget = TAnimationLoaderWidget(
            text: "Whoops! cart is empty",
            animation: TImages.cartAnimation,
            showAction: true,
            actionText: "Let's fill it",
            onActionPressed: () {
              if (navigator.canPop()) {
                navigator.pop();
              } else {
                mainController.changePage(0);
              }
            },
          );
          final cartItems = controller.user?.cart ?? [];
          double sum = 0;
      
          if (cartItems.isNotEmpty) {
            for (var e in cartItems) {
              try {
                final quantity = (e['quantity'] as num?)?.toDouble() ?? 0.0;
                final price = (e['product']['price'] as num?)?.toDouble() ?? 0.0;
                sum += quantity * price;
              } catch (e) {
                print('Error calculating cart item: $e');
                // Skip this item or handle error as needed
              }
            }
          }
          print("sum: $sum");
          print("cart items length: ${cartItems.length}");
      
          return cartItems.isEmpty
              ? emptyWidget
              : Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: canPop
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () => navigator.maybePop(),
                          )
                        : null,
                    title: Text(
                      'Cart',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    actions: [
                      if (cartItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => CheckoutScreen()),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              "Checkout \$$sum",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: CartItem(isDark: isDark),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
