import 'package:flutter/material.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';
import 'package:shop/utils/sizes/size.dart';

class VerticalProductShimmer extends StatelessWidget {
  const VerticalProductShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image..
            ShimmerEffect(width: 180, height: 180),
            SizedBox(height: TSizes.spaceBtwItems),

            // text...
            ShimmerEffect(width: 160, height: 15),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            ShimmerEffect(width: 110, height: 15),
          ],
        ),
      ),
    );
  }
}
