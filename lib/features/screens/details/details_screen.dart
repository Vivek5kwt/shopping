import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/controllers/cart_controller/cart.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/curv_widgets/curv_widget.dart';
import 'package:shop/utils/favourite_icon/favourite_icon.dart';
import 'package:shop/utils/product/rating_bars.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';

import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

import 'components/color_dot.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final ValueNotifier<int> _selectedImageNotifier;
  late final ValueNotifier<int> _selectedColorNotifier;

  // Define available colors
  final List<Color> availableColors = const [
    Color(0xFFBEE8EA),
    Color(0xFF141B4A),
    Color(0xFFF4E5C3),
  ];
  @override
  void initState() {
    super.initState();
    _selectedImageNotifier = ValueNotifier(0);
    final defaultColorIndex = availableColors.length > 1 ? 1 : 0;
    _selectedColorNotifier = ValueNotifier(defaultColorIndex);
  }

  @override
  void dispose() {
    _selectedImageNotifier.dispose();
    _selectedColorNotifier.dispose();
    super.dispose();
  }

  bool _isNetworkImage(String imagePath) {
    return imagePath.startsWith('http');
  }

  Widget _buildPrimaryImage(BuildContext context, String image) {
    if (image.isEmpty) {
      return const Icon(Icons.error_outline, size: 64, color: Colors.grey);
    }

    final isNetwork = _isNetworkImage(image);

    final imageWidget = isNetwork
        ? CachedNetworkImage(
            key: ValueKey('network-$image'),
            imageUrl: image,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (_, __, downloadProgress) =>
                CircularProgressIndicator(
              value: downloadProgress.progress,
              color: TColors.primary,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : Image.asset(
            image,
            key: ValueKey('asset-$image'),
            fit: BoxFit.contain,
          );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: imageWidget,
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: TColors.tealColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomeAppbar(
        showbackArrow: true,
        actions: [
          FavouriteIcon(
            color: Colors.grey.shade100,
            productId: widget.product.id!,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CurveWidget(
              child: Container(
                color: isDark ? TColors.darkerGrey : TColors.light,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          TSizes.productImageRadius * 2,
                        ),
                        child: Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: ValueListenableBuilder<int>(
                              valueListenable: _selectedImageNotifier,
                              builder: (context, index, _) {
                                final images = widget.product.images;
                                final image = (images.isNotEmpty &&
                                        index >= 0 &&
                                        index < images.length)
                                    ? images[index]
                                    : '';
                                return _buildPrimaryImage(context, image);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Image Slider...
                    Positioned(
                      right: 0,
                      bottom: 30,
                      left: TSizes.defaultSpace,
                      child: SizedBox(
                        height: 80,
                        child: ValueListenableBuilder<int>(
                          valueListenable: _selectedImageNotifier,
                          builder: (context, selectedIndex, _) {
                            return ListView.separated(
                              itemCount: widget.product.images.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: TSizes.spaceBtwItems),
                              itemBuilder: (context, index) {
                                final image = widget.product.images[index];
                                final isSelected = selectedIndex == index;

                                return RoundedImage(
                                  isNetworkImage: _isNetworkImage(image),
                                  width: 80,
                                  image: image,
                                  backgroundColor: isDark
                                      ? TColors.dark
                                      : TColors.white,
                                  border: Border.all(
                                    color: isSelected
                                        ? TColors.tealColor
                                        : Colors.transparent,
                                    width: isSelected
                                        ? 2
                                        : 1, // Make selected border thicker
                                  ),
                                  padding: const EdgeInsets.all(TSizes.sm),
                                  onPressed: () {
                                    if (_selectedImageNotifier.value != index) {
                                      _selectedImageNotifier.value = index;
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding * 1.2),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                defaultPadding,
                defaultPadding * 2,
                defaultPadding,
                defaultPadding,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(defaultBorderRadius * 3),
                  topRight: Radius.circular(defaultBorderRadius * 3),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        Text(
                          "\$${widget.product.price.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.titleLarge!.apply(
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: TSizes.spaceBtwSections,
                      ),
                      child: Text(
                        widget.product.descriptions,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(height: 1.5),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Colors",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: defaultPadding / 2),
                            ValueListenableBuilder<int>(
                              valueListenable: _selectedColorNotifier,
                              builder: (context, selectedColor, _) {
                                return Row(
                                  children: List.generate(
                                    availableColors.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        if (_selectedColorNotifier.value !=
                                            index) {
                                          _selectedColorNotifier.value = index;
                                        }
                                      },
                                      child: ColorDot(
                                        color: availableColors[index],
                                        isActive: selectedColor == index,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ratings",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: defaultPadding / 2),

                            RatingBars(product: widget.product),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product details',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Category', widget.product.category,
                              Icons.category_outlined),
                          _buildInfoRow(
                            'Availability',
                            widget.product.quantity > 0
                                ? '${widget.product.quantity} in stock'
                                : 'Out of stock',
                            Icons.check_circle_outline,
                          ),
                          _buildInfoRow(
                            'Shipping',
                            r'Free standard shipping on orders over $50',
                            Icons.local_shipping_outlined,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),
                    Consumer2<CartProvider, AuthProvider>(
                      builder: (context, cartProvider, authProvider, chid) {
                        return Center(
                          child: SizedBox(
                            width: 200,

                            child: widget.product.quantity > 0
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await cartProvider.addToCart(
                                        context: context,
                                        product: widget.product,
                                        currentUser: authProvider.user!,
                                        onUserUpdate: (updatedUser) {
                                          authProvider.setUserFromModel(
                                            updatedUser,
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: primaryColor,
                                      shape: const StadiumBorder(),
                                      side: BorderSide.none,
                                    ),

                                    child: const Text(
                                      "Add to Cart",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFEF4444,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Out of Stock",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
