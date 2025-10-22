class Rating {
  final String userId;
  final double rating;

  Rating({required this.userId, required this.rating});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'userId': userId, 'rating': rating};
  }

  factory Rating.fromJson(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }
}
