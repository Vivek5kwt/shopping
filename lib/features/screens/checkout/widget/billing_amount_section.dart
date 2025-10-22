import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';

import 'package:shop/utils/sizes/size.dart';

class BillingAmountSection extends StatelessWidget {
  const BillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
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
    // final subtotal = controller.totalPrice;
    return Column(
      children: [
        // subtotal...
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subtotal : ", style: Theme.of(context).textTheme.bodyMedium),
            Text("\$$sum", style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        // Shipping fee.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Shipping Fee : ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text("\$10", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),

        const SizedBox(height: TSizes.spaceBtwItems / 2),
        // Order Total fee.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Price : ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text("\$$total", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        // Order Total fee.
        // Consumer<CouponsController>(builder: (context, coupon, child) {
        //   if (coupon.appliedCoupons.id.isEmpty) {
        //     return const SizedBox.shrink();
        //   }
        //   return Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         "Discount:",
        //         style: Theme.of(context)
        //             .textTheme
        //             .bodyMedium!
        //             .apply(color: TColors.success),
        //       ),
        //       Text(
        //         coupon.getDiscountPrice(),
        //         style: Theme.of(context)
        //             .textTheme
        //             .titleMedium!
        //             .apply(color: TColors.success),
        //       ),
        //     ],
        //   );
        // }),
      ],
    );
  }
}
