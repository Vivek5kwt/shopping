import 'package:shop/utils/enums/auth_enums.dart';

class PaymentModel {
  String name;
  String image;
  PaymentMethods paymentMethod;
  PaymentModel({
    required this.image,
    required this.name,
    required this.paymentMethod,
  });

  static PaymentModel empty() => PaymentModel(
    image: '',
    name: '',
    paymentMethod: PaymentMethods.creditCard,
  );
}
