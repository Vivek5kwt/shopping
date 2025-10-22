// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/features/screens/home/home_screen.dart';

// class NavigationProvider extends ChangeNotifier {
//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   void updateIndex(int index) {
//     _selectedIndex = index;
//     notifyListeners();
//   }

//   final pages = [
//     const HomeScreen(),
//     const StoreScreen(),
//     const FavoriteScreen(),
//   //  const ProfileScreen(),
//   ];
// }

// class BottomNavBar extends StatelessWidget {
//   const BottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = THelperFunctions.isDarkMode(context);
//     return ChangeNotifierProvider(
//       create: (_) => NavigationProvider(),
//       child: Scaffold(
//         bottomNavigationBar: Consumer<NavigationProvider>(
//           builder: (context, controller, _) => NavigationBar(
//             height: 80,
//             elevation: 0,
//             selectedIndex: controller.selectedIndex,
//             backgroundColor: isDark ? TColors.black : TColors.white,
//             indicatorColor: isDark
//                 ? TColors.white.withOpacity(0.1)
//                 : TColors.black.withOpacity(0.1),
//             onDestinationSelected: (index) => controller.updateIndex(index),
//             destinations: const [
//               NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
//               NavigationDestination(icon: Icon(Iconsax.shop), label: "Store"),
//               NavigationDestination(
//                   icon: Icon(Iconsax.heart), label: "Wishlist"),
//               NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
//             ],
//           ),
//         ),
//         body: Consumer<NavigationProvider>(
//           builder: (context, controller, _) =>
//               controller.pages[controller.selectedIndex],
//         ),
//       ),
//     );
//   }
// }
