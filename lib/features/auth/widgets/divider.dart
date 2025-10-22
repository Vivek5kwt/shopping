import 'package:flutter/material.dart';
import 'package:shop/responsive/responsiveness.dart';

class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveBreakpoint.isMobile(context) ? 14 : 16,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
      ],
    );
  }
}
