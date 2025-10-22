import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/controllers/checkout/check_out_controller.dart';
import 'package:shop/utils/rounded_container/rounded_container.dart';
import 'package:shop/utils/section_header/sections_header.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class BillingPaymentMethod extends StatelessWidget {
  const BillingPaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Consumer<CheckOutController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            SectionHeader(
              title: 'Payment Method',
              buttonTitle: 'Change',
              onPressed: () => controller.selectPaymentMethod(context),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              children: [
                RoundedContainer(
                  width: 60,
                  height: 35,
                  backgroundColor: isDark ? TColors.light : TColors.white,
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Image.asset(
                    controller.paymentModel.image,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Text(
                  controller.paymentModel.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
