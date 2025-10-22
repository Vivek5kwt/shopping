import 'package:shop/features/auth/model/rating.dart';

class ProductModel {
  final String name;
  final String descriptions;
  final double price;
  final int quantity;
  final List<String> images;
  final String category;
  final String? id;
  final List<Rating>? rating;
  ProductModel({
    required this.name,
    required this.descriptions,
    required this.price,
    required this.quantity,
    required this.images,
    required this.category,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'descriptions': descriptions,
      'price': price,
      'quantity': quantity,
      'images': images,
      'category': category,
      'id': id,
      'rating': rating,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      descriptions: map['descriptions'] ?? '',
      price: (map['price'] ?? 0).toDouble(), // Convert to double
      quantity: (map['quantity'] ?? 0.toInt()), // Convert to double
      images: List<String>.from(map['images'] ?? []), // Handle null case
      category: map['category'] ?? '',
      id: map['_id'] != null ? map['_id'] as String : null,
      rating: map['ratings'] != null
          ? List<Rating>.from(map['ratings']?.map((x) => Rating.fromJson(x)))
          : null,
    );
  }
}
