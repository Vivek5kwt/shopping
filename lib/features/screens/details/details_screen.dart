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
  late String currentImage;
  late int selectedImageIndex;
  int selectedColorIndex = 1; // Add this for color selection tracking

  // Define available colors
  final List<Color> availableColors = const [
    Color(0xFFBEE8EA),
    Color(0xFF141B4A),
    Color(0xFFF4E5C3),
  ];
  @override
  void initState() {
    super.initState();
    // Initialize the current image and selected index
    currentImage = widget.product.images.isNotEmpty
        ? widget.product.images[0]
        : '';
    selectedImageIndex = 0;
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
                          child: CachedNetworkImage(
                            key: ValueKey(
                              currentImage,
                            ), // Add this key to force rebuild
                            imageUrl: currentImage,
                            height: MediaQuery.of(context).size.height * 0.4,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder:
                                (_, __, downloadProgress) =>
                                    CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      color: TColors.primary,
                                    ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
                        child: ListView.separated(
                          itemCount: widget.product.images.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: TSizes.spaceBtwItems),
                          itemBuilder: (context, index) {
                            final image = widget.product.images[index];
                            final isSelected =
                                selectedImageIndex ==
                                index; // Use index instead

                            return RoundedImage(
                              isNetworkImage: true,
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
                                print(
                                  "Image selected: $image at index: $index",
                                ); // Debug print
                                setState(() {
                                  currentImage = image;
                                  selectedImageIndex = index;
                                });
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
                      child: Text(widget.product.descriptions),
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
                            Row(
                              children: List.generate(
                                availableColors.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColorIndex = index;
                                    });
                                  },
                                  child: ColorDot(
                                    color: availableColors[index],
                                    isActive: selectedColorIndex == index,
                                  ),
                                ),
                              ),
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
