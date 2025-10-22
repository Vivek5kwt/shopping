import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.fit = BoxFit.cover,
    this.widht = 56,
    this.heigth = 56,
    this.padding = TSizes.sm,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
  });

  final BoxFit? fit;
  final double widht, heigth, padding;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor, backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      width: widht,
      height: heigth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor ?? (isDark ? TColors.black : TColors.white),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: SizedBox(
            width: widht - (padding * 2),
            height: heigth - (padding * 2),
            child: isNetworkImage
                ? CachedNetworkImage(
                    fit: fit,
                    color: overlayColor,
                    imageUrl: image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => ShimmerEffect(
                          width: widht - (padding * 2),
                          height: heigth - (padding * 2),
                          radius: (widht - (padding * 2)) / 2,
                        ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.error,
                        size: (widht - (padding * 2)) / 2,
                      ),
                    ),
                  )
                : Image(
                    fit: fit,
                    image: AssetImage(image),
                    color: overlayColor,
                  ),
          ),
        ),
      ),
    );
  }
}
