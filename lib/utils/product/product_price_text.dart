import 'package:flutter/material.dart';

class ProductPriceText extends StatelessWidget {
  const ProductPriceText(
      {super.key,
      this.currencySign = '\$',
      this.price,
      this.maxline = 1,
      this.isLage = false,
      this.lineThrough = false});
  final currencySign, price;
  final int maxline;
  final bool isLage;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxline,
      overflow: TextOverflow.ellipsis,
      currencySign + price,
      style: isLage
          ? Theme.of(context).textTheme.headlineMedium!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
