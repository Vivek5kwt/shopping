class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String profilePic;
  final String address;
  final String type;
  final List<dynamic> cart;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.profilePic,
    required this.address,
    required this.password,
    required this.cart,
  });

  static UserModel empty() => UserModel(
    id: "",
    name: "",
    email: "",
    password: "",
    profilePic: "",
    address: '',
    type: '',
    cart: [],
  );

  // copyWith function
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? profilePic,
    String? type,
    String? address,
    List<dynamic>? cart,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      type: type ?? this.type,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'type': type,
      'address': address,
      "password": password,
      "cart": cart,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      profilePic: json['profilePic'] ?? '',
      cart: json['cart'] != null
          ? (json['cart'] as List).map((item) {
              // Safely convert each cart item, handling type mismatches
              return {
                '_id': item['_id'] ?? '',
                'quantity': (item['quantity'] as num?)?.toInt() ?? 0,
                'product': item['product'] != null
                    ? {
                        '_id': item['product']['_id'] ?? '',
                        'name': item['product']['name'] ?? '',
                        'description': item['product']['description'] ?? '',
                        'price':
                            (item['product']['price'] as num?)?.toDouble() ??
                            0.0,
                        'quantity':
                            (item['product']['quantity'] as num?)?.toInt() ?? 0,
                        'images': item['product']['images'] ?? [],
                        'category': item['product']['category'] ?? '',
                      }
                    : {},
              };
            }).toList()
          : [], // Return empty list if cart is null
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePic: $profilePic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        profilePic.hashCode;
  }
}
