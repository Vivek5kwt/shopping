import 'package:flutter/material.dart';

class CurveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    final firstCurve = Offset(0, size.height - 20);
    final lastCuruve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstCurve.dx,
      firstCurve.dy,
      lastCuruve.dx,
      lastCuruve.dy,
    );

    final secondfirstCurve = Offset(0, size.height - 20);
    final secondlastCuruve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      secondfirstCurve.dx,
      secondfirstCurve.dy,
      secondlastCuruve.dx,
      secondlastCuruve.dy,
    );
    final thirdfirstCurve = Offset(size.width, size.height - 20);
    final thirdlastCuruve = Offset(size.width, size.height);
    path.quadraticBezierTo(
      thirdfirstCurve.dx,
      thirdfirstCurve.dy,
      thirdlastCuruve.dx,
      thirdlastCuruve.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
