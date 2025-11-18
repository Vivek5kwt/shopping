import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/features/controllers/products/favorite_controller.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/circle_icon_button/circle_icon_button.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/image/images.dart';
import 'package:shop/utils/loaders/animation_loader.dart';
import 'package:shop/utils/product/vertical_product_container.dart';
import 'package:shop/utils/shimmer/product_shimmer.dart';
import 'package:shop/utils/sizes/size.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<FavoriteController>(
        context,
        listen: false,
      );
      controller.fetchFavorites(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    const lightBackground = Color(0xFFF8F8FF);
    final Color statusColor = isDark ? theme.scaffoldBackgroundColor : lightBackground;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: statusColor,
        appBar: CustomeAppbar(
          showbackArrow: true,
          title: Text(
            "Wishlist",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            CircleIconButton(
              icon: Icons.add,
              onPressed: () => Get.to(() => const MainWrapper(initialIndex: 0)),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Consumer<FavoriteController>(
                builder: (context, controller, child) {
                  final emptyAnimation = TAnimationLoaderWidget(
                    text: "Whoops! WishList is Empty...",
                    animation: TImages.pencilAnimations,
                    showAction: true,
                    actionText: 'Let\'s add some',
                    onActionPressed: () =>
                        Get.to(() => const MainWrapper(initialIndex: 0)),
                  );

                  const loader = VerticalProductShimmer();

                  if (controller.isLoading) {
                    return loader;
                  }
                  if (controller.favoriteProducts.isEmpty) {
                    return emptyAnimation;
                  } else {
                    return GridLayout(
                      itemCount: controller.favoriteProducts.length,
                      itemBuilder: (_, index) => VerticalProductContainer(
                        productModel: controller.favoriteProducts[index],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
