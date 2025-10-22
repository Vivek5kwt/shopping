import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/custom_bottom_navbar.dart';
import 'package:shop/utils/image/images.dart';
import 'package:shop/utils/loaders/animation_loader.dart';

class OrderPlaced extends StatelessWidget {
  const OrderPlaced({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TAnimationLoaderWidget(
          text: "Order has been placed",
          animation: TImages.orderPlaced,
          showAction: true,
          actionText: "Continue",
          onActionPressed: () => Get.to(() => MainWrapper(initialIndex: 0)),
        ),
      ),
    );
  }
}
