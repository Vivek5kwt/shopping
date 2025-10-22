import 'package:flutter/material.dart';

/// Responsive utility class for mobile devices
/// Supports different screen sizes: small, medium, and large mobile devices
class ResponsiveUtils {
  final BuildContext context;

  ResponsiveUtils(this.context);

  /// Get screen width
  double get width => MediaQuery.of(context).size.width;

  /// Get screen height
  double get height => MediaQuery.of(context).size.height;

  /// Check if device is small mobile (width < 360)
  bool get isSmallMobile => width < 360;

  /// Check if device is medium mobile (360 <= width < 400)
  bool get isMediumMobile => width >= 360 && width < 400;

  /// Check if device is large mobile (width >= 400)
  bool get isLargeMobile => width >= 400;

  /// Get responsive width based on percentage
  double widthPercent(double percent) => width * (percent / 100);

  /// Get responsive height based on percentage
  double heightPercent(double percent) => height * (percent / 100);

  /// Get responsive font size
  double fontSize(double baseSize) {
    if (isSmallMobile) return baseSize * 0.85;
    if (isMediumMobile) return baseSize * 0.95;
    return baseSize;
  }

  /// Get responsive spacing
  double spacing(double baseSpacing) {
    if (isSmallMobile) return baseSpacing * 0.8;
    if (isMediumMobile) return baseSpacing * 0.9;
    return baseSpacing;
  }

  /// Get responsive icon size
  double iconSize(double baseSize) {
    if (isSmallMobile) return baseSize * 0.85;
    if (isMediumMobile) return baseSize * 0.92;
    return baseSize;
  }

  /// Get responsive padding
  EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    final multiplier = isSmallMobile ? 0.8 : (isMediumMobile ? 0.9 : 1.0);

    return EdgeInsets.only(
      left: (left ?? horizontal ?? all ?? 0) * multiplier,
      top: (top ?? vertical ?? all ?? 0) * multiplier,
      right: (right ?? horizontal ?? all ?? 0) * multiplier,
      bottom: (bottom ?? vertical ?? all ?? 0) * multiplier,
    );
  }

  /// Get responsive border radius
  double borderRadius(double baseRadius) {
    if (isSmallMobile) return baseRadius * 0.85;
    if (isMediumMobile) return baseRadius * 0.92;
    return baseRadius;
  }
}

/// Extension on BuildContext for easy access to ResponsiveUtils
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}

/// Responsive builder widget for custom responsive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveUtils responsive)
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, ResponsiveUtils(context));
  }
}

/// Responsive text widget
class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Text(
      text,
      style: TextStyle(
        fontSize: responsive.fontSize(fontSize),
        fontWeight: fontWeight,
        color: color,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ResponsiveSizedBox({super.key, this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return SizedBox(
      width: width != null ? responsive.spacing(width!) : null,
      height: height != null ? responsive.spacing(height!) : null,
      child: child,
    );
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? all;
  final double? horizontal;
  final double? vertical;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Padding(
      padding: responsive.padding(
        all: all,
        horizontal: horizontal,
        vertical: vertical,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: child,
    );
  }
}
