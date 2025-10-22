import 'package:flutter/material.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';
import 'package:shop/utils/theme/helper.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    this.width,
    this.height,
    this.size = TSizes.lg,
    required this.icon,
    this.backgroundColor,
    this.onPressed,
    this.color,
  });
  final double? width, height, size;
  final IconData icon;
  final Color? backgroundColor, color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : isDark
            ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: size, color: color),
      ),
    );
  }
}
