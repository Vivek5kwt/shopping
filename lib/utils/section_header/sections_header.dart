import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.buttonTitle = "View All",
    this.showActionbutton = true,
    this.onPressed,
    this.textColor,
  });
  final String title;
  final String buttonTitle;
  final bool showActionbutton;
  final void Function()? onPressed;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionbutton)
          TextButton(
              onPressed: onPressed,
              child: Text(
                buttonTitle,
              )),
      ],
    );
  }
}
