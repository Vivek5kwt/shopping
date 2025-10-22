import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop/features/screens/home/home_screen.dart';

import 'features/cart/view/cart_screen.dart';
import 'features/screens/favorite/view/favorite_screen.dart';
import 'features/screens/home/components/categories.dart';
import 'features/screens/profile/view/profile_screen.dart';

class MainController with ChangeNotifier {
  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    notifyListeners();
  }
}


class MainWrapper extends StatefulWidget {
  final int initialIndex;
  const MainWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MainController>(context, listen: false)
          .changePage(widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainController>(context);
    const pages = [
      HomeScreen(),
      Categories(),
      CartScreen(),
      FavoriteScreen(),
      ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      body: Stack(
        children: [
          IndexedStack(
            index: controller.currentIndex,
            children: pages,
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomBar(),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainController>(context);

    const selectedColor = Colors.deepPurple;
    const unselectedColor = Colors.grey;

    Widget navItem({
      required IconData icon,
      required String label,
      required int index,
      required VoidCallback onTap,
    }) {
      final isSelected = controller.currentIndex == index;

      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isSelected ? selectedColor : unselectedColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          height: 110, // Increased height to make space for floating Cart
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(height: 68), // Inner height of nav bar
                  ),
                ),
              ),

              // Nav items (left and right)
              Positioned(
                bottom: 18,
                left: 32,
                right: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side
                    Row(
                      children: [
                        navItem(
                          icon: Icons.home,
                          label: 'Home',
                          index: 0,
                          onTap: () => controller.changePage(0),
                        ),
                        const SizedBox(width: 20),
                        navItem(
                          icon: Icons.category,
                          label: 'Categories',
                          index: 1,
                          onTap: () => controller.changePage(1),
                        ),
                      ],
                    ),
                    // Right side
                    Row(
                      children: [
                        navItem(
                          icon: Icons.favorite,
                          label: 'Wishlist',
                          index: 3,
                          onTap: () => controller.changePage(3),
                        ),
                        const SizedBox(width: 20),
                        navItem(
                          icon: Iconsax.user,
                          label: 'Profile',
                          index: 4,
                          onTap: () => controller.changePage(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Floating Cart button (fully visible)
              Positioned(
                bottom: 25, // Lift it higher to float above bar
                child: GestureDetector(
                  onTap: () => controller.changePage(2),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: controller.currentIndex == 2
                              ? selectedColor
                              : Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: controller.currentIndex == 2
                              ? selectedColor
                              : unselectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

