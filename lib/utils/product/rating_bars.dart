import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/model/rating.dart';
import 'package:shop/features/controllers/products/rating_controller.dart';

class RatingBars extends StatefulWidget {
  final ProductModel product;
  const RatingBars({super.key, required this.product});

  @override
  State<RatingBars> createState() => _RatingBarsState();
}

class _RatingBarsState extends State<RatingBars> {
  double myRating = 0;
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.user?.id;
    if (currentUserId == null) return;

    final ratings = widget.product.rating ?? <Rating>[];
    for (final rating in ratings) {
      if (rating.userId == currentUserId) {
        myRating = rating.rating;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RatingController>(
      builder: (context, controller, child) {
        return RatingBar.builder(
          initialRating: myRating > 0 ? myRating : 0,
          itemCount: 5,
          itemSize: 20.0,

          direction: Axis.horizontal,
          minRating: 1,
          maxRating: 5,
          allowHalfRating: true,
          itemBuilder: (context, index) =>
              const Icon(Icons.star, color: Colors.amber),
          itemPadding: EdgeInsets.symmetric(horizontal: 2),
          onRatingUpdate: (value) =>
              controller.updateRating(context, widget.product, value),
        );
      },
    );
  }
}
