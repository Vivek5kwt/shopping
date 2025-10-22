import 'package:flutter/material.dart';
import 'package:shop/responsive/responsiveness.dart';

class AuthFooter extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthFooter({
    super.key,
    required this.question,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: TextStyle(
            fontSize: ResponsiveBreakpoint.isMobile(context) ? 16 : 18,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: ResponsiveBreakpoint.isMobile(context) ? 16 : 18,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
