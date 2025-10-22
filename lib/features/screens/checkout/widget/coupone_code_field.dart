// // CouponCodeField - Updated
// import 'package:ecom/common/widgets/rounded_container/rounded_container.dart';
// import 'package:ecom/features/shop/controllers/coupons/coupons_controller.dart';
// import 'package:ecom/utils/constants/colors.dart';
// import 'package:ecom/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CouponCodeField extends StatelessWidget {
//   const CouponCodeField({
//     super.key,
//     required this.isDark,
//   });

//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CouponsController>(builder: (context, controller, child) {
//       return RoundedContainer(
//         shadowBorder: true,
//         backgroundColor: isDark ? TColors.dark : TColors.white,
//         padding: const EdgeInsets.only(
//             top: TSizes.sm,
//             bottom: TSizes.sm,
//             right: TSizes.sm,
//             left: TSizes.md),
//         child: Row(
//           children: [
//             Flexible(
//               child: TextFormField(
//                 // **FIX: Use the TextEditingController**
//                 controller: controller.couponsCodeController,
//                 onChanged: (value) => controller.onChangeCoupons(value),
//                 decoration: const InputDecoration(
//                   hintText: 'Have a promo code? Enter here',
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                 ),
//               ),
//             ),

//             // apply button..
//             SizedBox(
//               width: 80,
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     // foregroundColor: isDark
//                     //     ? TColors.white.withValues(alpha: 0.5)
//                     //     : TColors.dark.withValues(alpha: 0.5),
//                     // backgroundColor: Colors.grey.withValues(alpha: 0.2),
//                     side: BorderSide(
//                         color: controller.couponsCodeController.text.isEmpty
//                             ? Colors.grey.withValues(alpha: 0.1)
//                             : TColors.primary.withValues(alpha: 0.1)),
//                   ),
//                   // **FIX: Call the apply method**
//                   onPressed: controller.appliedCoupons.id.isNotEmpty
//                       ? null
//                       : controller.couponsCodeController.text.isEmpty
//                           ? null
//                           : () => controller.applyinCoupons(),
//                   child: controller.isLoading
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: TColors.white,
//                           ),
//                         )
//                       : Text(controller.appliedCoupons.id.isEmpty
//                           ? 'Apply'
//                           : 'Applied')),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
