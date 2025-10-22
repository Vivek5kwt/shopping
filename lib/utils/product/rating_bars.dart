import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
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
    for (int i = 0; i < widget.product.rating!.length; i++) {
      if (widget.product.rating![i].userId ==
          Provider.of<AuthProvider>(context, listen: false).user!.id) {
        myRating = widget.product.rating![i].rating;
      }
    }

    super.initState();
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
