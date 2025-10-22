class Category {
  final String icon, title;

  Category({required this.icon, required this.title});
}

List<Category> demo_categories = [
  Category(icon: "assets/icons/basketball.png", title: "Sports"),
  Category(icon: "assets/icons/shirt.png", title: "Clothing"),
  Category(icon: "assets/icons/device.png", title: "Electronics"),
  Category(icon: "assets/icons/cosmetics.png", title: "Cosmetics"),
  Category(icon: "assets/icons/stack-of-books.png", title: "Books"),
  Category(icon: "assets/icons/menu.png", title: "Others"),
];
