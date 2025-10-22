import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';

PreferredSizeWidget buildAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(CupertinoIcons.bell, color: Color(0xFF6B7280)),
        onPressed: () {},
      ),
      Consumer<UserController>(
        builder: (context, controller, child) {
          return IconButton(
            icon: const Icon(Icons.logout_outlined, color: Color(0xFF6B7280)),
            onPressed: () => controller.logout(context),
          );
        },
      ),
    ],
  );
}
