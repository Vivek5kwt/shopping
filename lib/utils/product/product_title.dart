import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  const ProductTitle(
      {super.key,
      required this.title,
      this.smallSize = false,
      this.maxline = 2,
      this.align = TextAlign.left});
  final String title;
  final bool smallSize;
  final int maxline;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
        textAlign: align,
        maxLines: maxline,
        overflow: TextOverflow.ellipsis,
        title,
        style: smallSize
            ? Theme.of(context).textTheme.labelLarge
            : Theme.of(context).textTheme.titleSmall);
  }
}
