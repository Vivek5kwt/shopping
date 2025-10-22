import 'package:flutter/material.dart';

/// ====== RESPONSIVE HELPERS ======
class Responsive {
  final BuildContext context;
  final double w;
  final double h;

  /// Breakpoints tuned for common phone widths
  late final bool isSmall = w < 360;
  late final bool isMedium = w >= 360 && w < 420;
  late final bool isLarge = w >= 420;

  Responsive(this.context)
    : w = MediaQuery.of(context).size.width,
      h = MediaQuery.of(context).size.height;

  double scale(double small, double medium, double large) {
    if (isSmall) return small;
    if (isMedium) return medium;
    return large;
  }

  double text(double small, double medium, double large) =>
      scale(small, medium, large);
}
