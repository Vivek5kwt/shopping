import 'package:flutter/material.dart';
import 'package:shop/utils/curv_widgets/curv_clip.dart';

class CurveWidget extends StatelessWidget {
  const CurveWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CurveClip(), child: child);
  }
}
