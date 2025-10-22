import 'dart:math';

import 'package:flutter/material.dart';

class CustomCircularProgressPainter extends CustomPainter {
  final double progress; // Value between 0.0 and 1.0

  CustomCircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      backgroundPaint,
    );

    // Draw progress arc
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round; // Optional: rounded ends for the arc

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
