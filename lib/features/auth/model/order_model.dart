import 'package:shop/features/admin/features/models/product_model.dart';

class OrderModel {
  final String id;
  final List<ProductModel> products;
  final List<int> quantity;
  final String address;
  final int status;
  final int orderedAt;
  final String userId;
  final double totalPrice;

  OrderModel({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.status,
    required this.orderedAt,
    required this.totalPrice,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toJson()).toList(),
      'quantity': quantity,
      'address': address,
      'status': status,
      'orderedAt': orderedAt,
      'userId': userId,
      'totalPrice': totalPrice,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      id: map['_id'] ?? '',
      products: List<ProductModel>.from(
        map['products']?.map((x) => ProductModel.fromJson(x['product'])),
      ),
      quantity: List<int>.from(map['products']?.map((x) => x['quantity'])),
      address: map['address'] ?? '',
      status: map['status']?.toInt() ?? 0,
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      userId: map['userId'] ?? '',
    );
  }
}
