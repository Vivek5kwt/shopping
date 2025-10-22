import 'package:flutter/material.dart';
import 'package:shop/features/models/payment.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/image/images.dart';
import 'package:shop/utils/payment_tile/payment_tile.dart';
import 'package:shop/utils/section_header/sections_header.dart';
import 'package:shop/utils/sizes/size.dart';

class CheckOutController with ChangeNotifier {
  final bool _isLoading = false;
  PaymentModel _paymentModel = PaymentModel.empty();

  // Getter for paymentModel
  bool get isLoading => _isLoading;
  PaymentModel get paymentModel => _paymentModel;

  // Add a setter for paymentModel
  set paymentModel(PaymentModel model) {
    _paymentModel = model;
    notifyListeners(); // Notify listeners about the change
  }

  CheckOutController() {
    _paymentModel = PaymentModel(
      image: TImages.paypal,
      name: "Cash on delivery",
      paymentMethod: PaymentMethods.cashOnDelivery,
    );
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            children: [
              // header section...
              const SectionHeader(
                title: "Select Payment Method",
                showActionbutton: false,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.paypal,
                  name: "Paypal",
                  paymentMethod: PaymentMethods.paypal,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.creditCard,
                  name: "Credit Card/Debit Card",
                  paymentMethod: PaymentMethods.creditCard,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.googlePay,
                  name: "Google Pay",
                  paymentMethod: PaymentMethods.googlePay,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.applePay,
                  name: "Apple Pay",
                  paymentMethod: PaymentMethods.applePay,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.visa,
                  name: "VISA",
                  paymentMethod: PaymentMethods.visa,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),

              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.paytm,
                  name: "Paytm",
                  paymentMethod: PaymentMethods.paytm,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              PaymentTile(
                paymentModel: PaymentModel(
                  image: TImages.paystack,
                  name: "Paystack",
                  paymentMethod: PaymentMethods.paystack,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> checkOut(BuildContext context, double totalAmount) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();
  //     final order = Provider.of<OrderController>(context, listen: false);
  //     final stripeService = StripeServices();
  //     PaymentMethods paymentMethods = _paymentModel.paymentMethod;
  //     switch (paymentMethods) {
  //       case PaymentMethods.creditCard:
  //         await stripeService.initPaymentSheet("USD", totalAmount.toInt());
  //         await stripeService.showPaymentSheet();
  //       case PaymentMethods.cashOnDelivery:
  //         break;
  //       default:
  //         throw "Payment method is not supported";
  //     }
  //     _isLoading = false;
  //     notifyListeners();
  //     print("Total Price while checking out $totalAmount");
  //     order.processOrders(context, totalAmount);
  //     final controller = Provider.of<CouponsController>(context, listen: false);
  //     controller.decreaseCounpon();
  //     controller.addCurrentUsertoCoupons();
  //     // **FIX: Clear the applied coupon after successful order processing**
  //     controller.resetCouponState(); // Add this line
  //   } catch (e) {
  //     _isLoading = false;
  //     notifyListeners();
  //     TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
  //   }
  // }
}
