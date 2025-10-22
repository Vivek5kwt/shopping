import 'package:flutter/material.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/theme/colors.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    super.key,
    this.width,
    this.height,
    this.radius = TSizes.cardRadiusLg,
    this.child,
    this.shadowBorder = false,
    this.backgroundColor = TColors.white,
    this.borderColor = TColors.borderPrimary,
    this.padding,
    this.margin,
  });
  final double? width, height;
  final double radius;
  final Widget? child;
  final bool shadowBorder;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: shadowBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
