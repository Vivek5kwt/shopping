import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';
import 'package:shop/features/cart/widget/cart.dart';
import 'package:shop/features/controllers/order/order_controller.dart';
import 'package:shop/features/screens/checkout/widget/billing_address_section.dart';
import 'package:shop/features/screens/checkout/widget/billing_amount_section.dart';
import 'package:shop/features/screens/checkout/widget/billing_payment_method.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/utils/rounded_container/rounded_container.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = Provider.of<AuthProvider>(context, listen: false);
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
    double total = sum + 10.0;

    return Scaffold(
      appBar: CustomeAppbar(
        showbackArrow: true,
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              CartItem(isDark: isDark, showaddremovebutton: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Coupone field..
              RoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                shadowBorder: true,
                backgroundColor: isDark ? TColors.black : TColors.white,
                child: const Column(
                  children: [
                    // Pricing
                    BillingAmountSection(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    // divider
                    Divider(),
                    SizedBox(height: TSizes.spaceBtwItems),

                    // Payment Methods
                    BillingPaymentMethod(),

                    SizedBox(height: TSizes.spaceBtwItems),
                    //Billing  Address
                    BillingAddressSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Consumer3<OrderController, AuthProvider, UserController>(
          builder:
              (
                context,
                orderController,
                authController,
                userController,
                child,
              ) {
                final hasAddress =
                    userController.user?.address.isNotEmpty ?? false;
                print("address : ${userController.user?.address}");

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasAddress
                        ? () => orderController.placeOrder(
                            context: context,
                            address: userController.user!.address,
                            totalPrice: total,
                            currentUser: userController.user!,
                            onUserUpdate: (updatedUser) {
                              authController.setUserFromModel(updatedUser);
                            },
                          )
                        : () {
                            CustomSnackbars.showWarning(
                              context,
                              "⚠️ Heads Up!",
                              'Please add a shipping address first',
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      backgroundColor: hasAddress ? null : Colors.grey,
                    ),
                    child: Text(
                      hasAddress
                          ? "Checkout \$$total"
                          : "Add Address to Checkout",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
        ),
      ),
    );
  }
}
