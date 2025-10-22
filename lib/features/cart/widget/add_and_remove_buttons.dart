import 'package:flutter/material.dart';

import 'package:shop/utils/circle_icon_button/circle_icon_button.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';

class AddandRemoveButtons extends StatelessWidget {
  const AddandRemoveButtons({
    super.key,
    required this.isDark,
    this.add,
    this.remove,
    required this.quantity,
  });

  final bool isDark;
  final int quantity;
  final VoidCallback? add, remove;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(
          onPressed: remove,
          icon: Icons.remove,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: isDark ? TColors.white : TColors.black,
          backgroundColor: isDark ? TColors.darkerGrey : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        CircleIconButton(
          onPressed: add,
          icon: Icons.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: TColors.white,
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }
}
