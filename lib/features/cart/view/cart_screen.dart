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
  const CartScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final mainController = context.read<MainController>();

    return SafeArea(
      child: Consumer<AuthProvider>(
        builder: (context, controller, child) {
          final navigator = Navigator.of(context);
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
      
          final body = AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: cartItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: emptyWidget,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.withOpacity(0.05),
                          Colors.purple.withOpacity(0.04),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            TSizes.defaultSpace,
                            TSizes.defaultSpace,
                            TSizes.defaultSpace,
                            0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Review your cart",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Make sure everything looks perfect before you checkout.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color
                                                ?.withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections / 2),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(
                              left: TSizes.defaultSpace,
                              right: TSizes.defaultSpace,
                              bottom: TSizes.defaultSpace,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(TSizes.md),
                                child: CartItem(isDark: isDark),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: showBackButton
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
                    child: Chip(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      label: Text(
                        "Items: ${cartItems.length}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
              ],
            ),
            body: body,
            bottomNavigationBar: cartItems.isEmpty
                ? null
                : Container(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Shipping calculated at checkout",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color
                                              ?.withOpacity(0.7),
                                        ),
                                  ),
                                ],
                              ),
                              Text(
                                "\$${sum.toStringAsFixed(2)}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_bag_outlined),
                              onPressed: () => Get.to(
                                () => const CheckoutScreen(),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: TSizes.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              label: Text(
                                "Proceed to Checkout (\$${sum.toStringAsFixed(2)})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
