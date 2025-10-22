import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:provider/provider.dart';
import 'package:shop/features/controllers/products/favorite_controller.dart';
import 'package:shop/utils/circle_icon_button/circle_icon_button.dart';

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({super.key, required this.productId, this.color});
  final String productId;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteController>(
      builder: (context, controller, child) {
        return CircleIconButton(
          icon: controller.isFavorite(productId)
              ? Iconsax.heart
              : Icons.favorite_border_outlined,
          color: controller.isFavorite(productId) ? Colors.red : null,
          onPressed: () => controller.toggleFavorite(context, productId),
        );
      },
    );
  }
}
