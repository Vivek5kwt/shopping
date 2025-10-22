import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';
import 'package:shop/utils/sizes/size.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.applyradius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
  });
  final String image;
  final double? width, height;
  final bool applyradius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyradius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      ShimmerEffect(width: width, height: height),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(fit: fit, image: AssetImage(image)),
        ),
      ),
    );
  }
}
