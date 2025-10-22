import 'package:flutter/material.dart';
import 'package:shop/responsive/responsiveness.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveBreakpoint.isMobile(context) ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: ResponsiveBreakpoint.isMobile(context) ? 16 : 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
