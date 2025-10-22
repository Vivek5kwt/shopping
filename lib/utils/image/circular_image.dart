import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePictureContainer extends StatelessWidget {
  final String avatarUrl;
  final double radius;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? errorWidget;
  final BoxFit fit;

  const ProfilePictureContainer({
    super.key,
    required this.avatarUrl,
    this.radius = 28.0,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          fit: fit,
          placeholder: (context, url) => _buildShimmerEffect(theme),
          errorWidget: (context, url, error) => _buildErrorWidget(theme),
          width: radius * 2,
          height: radius * 2,
        ),
      ),
    );
  }

  Widget _buildShimmerEffect(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor ?? Colors.grey[300]!,
      highlightColor: shimmerHighlightColor ?? Colors.grey[100]!,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return errorWidget ??
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: radius * 1.2,
            color: theme.colorScheme.onErrorContainer,
          ),
        );
  }
}
