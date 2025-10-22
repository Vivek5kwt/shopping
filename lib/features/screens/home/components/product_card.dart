import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/utils/rounded_image/rounded_image.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.press,
    required this.bgColor,
    this.isNetwork = false,
    this.isLoading = false,
  });
  final String image, title;
  final VoidCallback press;
  final double price;
  final Color bgColor;
  bool isNetwork;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(defaultBorderRadius),
                ),
              ),
              child: isLoading
                  ? ShimmerEffect(width: 180, height: 180)
                  : RoundedImage(
                      image: image,
                      applyradius: true,
                      isNetworkImage: isNetwork,
                    ),
              // child:  isNetwork
              //     ? Image.network(image, height: 132)
              //     : Image.asset(image, height: 132),
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: defaultPadding / 4),
                Text(
                  "\$${price.toStringAsFixed(2)}",

                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.apply(color: Color(0xFF059669)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
