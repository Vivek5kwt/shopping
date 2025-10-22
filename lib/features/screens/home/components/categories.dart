import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/models/Category.dart';
import 'package:shop/features/screens/products_categories/view/categories_products.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Reduced from 104
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        itemCount: demo_categories.length,
        itemBuilder: (context, index) => CategoryCard(
          icon: demo_categories[index].icon,
          title: demo_categories[index].title,
          press: () => Get.to(
            () => CategoriesProducts(category: demo_categories[index].title),
          ),
        ),
        separatorBuilder: (context, index) =>
            const SizedBox(width: 15), // Reduced spacing
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.press,
  });

  final String icon, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    // Make width responsive based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 360 ? 70.0 : 75.0;

    return SizedBox(
      width: cardWidth, // Fixed compact width
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(defaultBorderRadius),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8, // Reduced padding
            horizontal: 6, // Reduced padding
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 28, // Reduced from 20
                width: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6), // Reduced spacing
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 11, // Smaller font size
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
