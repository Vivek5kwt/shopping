import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/controllers/checkout/check_out_controller.dart';

import 'package:shop/features/models/payment.dart';
import 'package:shop/utils/rounded_container/rounded_container.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.paymentModel});
  final PaymentModel paymentModel;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CheckOutController>(context, listen: false);
    final isDark = THelperFunctions.isDarkMode(context);
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        controller.paymentModel = paymentModel;
        Navigator.pop(context);
      },
      leading: RoundedContainer(
        height: 40,
        width: 60,
        backgroundColor: isDark ? TColors.light : TColors.white,
        padding: const EdgeInsets.all(TSizes.sm),
        child: Image.asset(paymentModel.image, fit: BoxFit.contain),
      ),
      title: Text(paymentModel.name),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
