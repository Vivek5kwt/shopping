import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/cart/view/cart_screen.dart';
import 'package:shop/features/screens/home/notification_screen.dart';
import 'package:shop/features/screens/profile/view/addresses_screen.dart';

import 'components/categories.dart';
import 'components/new_arrival_products.dart';
import 'components/search_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _recentKey = GlobalKey();
  final GlobalKey _trendingKey = GlobalKey();

  // Sample product data. Replace with real data source or provider integration.
  // According to user request, we only show sold T-shirts in the Recent and Trending sections.
  final List<Map<String, dynamic>> _sampleProducts = [
    {
      'id': 1,
      'title': 'Classic White T-Shirt',
      'image': 'assets/images/tshirt_white.png',
      'isTshirt': true,
      'sold': true,
      'price': 19.99,
    },
    {
      'id': 2,
      'title': 'Black Logo Tee',
      'image': 'assets/images/tshirt_black.png',
      'isTshirt': true,
      'sold': true,
      'price': 24.99,
    },
    {
      'id': 3,
      'title': 'Blue V-Neck T-Shirt',
      'image': 'assets/images/tshirt_blue.png',
      'isTshirt': true,
      'sold': false,
      'price': 21.50,
    },
    {
      'id': 4,
      'title': 'Graphic Tee (Limited)',
      'image': 'assets/images/tshirt_graphic.png',
      'isTshirt': true,
      'sold': true,
      'price': 29.99,
    },
    // Add more mock items if you want
  ];

  List<Map<String, dynamic>> get _soldTshirts =>
      _sampleProducts.where((p) => p['isTshirt'] == true && p['sold'] == true).toList();

  Future<void> _scrollToKey(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
    // Optionally close the drawer when navigation happens
    if (Scaffold.maybeOf(context) != null) Navigator.of(context).maybePop();
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: navigate to product details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product['title']} tapped')),
          );
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Use placeholder if asset doesn't exist
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: product['image'] != null
                      ? DecorationImage(
                          image: AssetImage(product['image']),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product['image'] == null
                    ? const Center(child: Icon(Iconsax.gallery, size: 36, color: Colors.grey))
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Text(
                  product['title'] ?? 'Unnamed',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(
                  "\$${(product['price'] ?? 0).toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: defaultPadding / 2, bottom: defaultPadding / 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Sold',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Badge count for notifications (sample)
    int notificationCount = 3;
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    const lightBackground = Color(0xFFF8F8FF);
    final Color statusColor = isDark ? theme.scaffoldBackgroundColor : lightBackground;

    void openNotifications() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      );
    }

    void openCart() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    }

    void openAddresses() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AddressesScreen()),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: statusColor,
        drawer: Drawer(
          child: SafeArea(
            child: Consumer<AuthProvider>(
              builder: (context, controller, _) {
                final user = controller.user;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF111827), Color(0xFF1F2937)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white.withOpacity(.1),
                            child: const Icon(Iconsax.shop, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: defaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name.isNotEmpty == true ? user!.name : 'Guest',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? 'Sign in to personalize your feed',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            _DrawerStat(title: 'Orders', value: '12'),
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(),
                            ),
                            _DrawerStat(title: 'Wishlist', value: '8'),
                            const SizedBox(
                              height: 40,
                              child: VerticalDivider(),
                            ),
                            _DrawerStat(title: 'Cart', value: '${user?.cart.length ?? 0}'),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Recent View'),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Future.microtask(() => _scrollToKey(_recentKey));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.trending_up),
                      title: const Text('Trending (T-shirts)'),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        Future.microtask(() => _scrollToKey(_trendingKey));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.notification),
                      title: const Text('Notifications'),
                      trailing: notificationCount > 0
                          ? CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Text(
                                '$notificationCount',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.of(context).maybePop();
                        openNotifications();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.shopping_bag),
                      title: const Text('My Bag'),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        openCart();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Iconsax.location),
                      title: const Text('Saved Addresses'),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        openAddresses();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('My Orders'),
                      subtitle: const Text('Track & manage recent purchases'),
                      onTap: () {
                        Navigator.of(context).maybePop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Orders coming soon!')),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  // Open drawer reliably
                  Scaffold.of(context).openDrawer();
                },
                icon: SvgPicture.asset("assets/icons/menu.svg"),
              );
            },
          ),
          title: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: openAddresses,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/icons/Location.svg"),
                const SizedBox(width: defaultPadding / 2),
                Consumer<AuthProvider>(
                  builder: (context, controller, _) {
                    final address = controller.user?.address;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address != null && address.isNotEmpty ? address : "15/2 New Texas",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Text(
                          'Manage address',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            // Notification icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.grey),
                  onPressed: openNotifications,
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            Consumer<AuthProvider>(
              builder: (context, controller, child) {
                // Safely get cart count
                final cartCount = controller.user?.cart.length ?? 0;

                debugPrint("Cart count in home page: $cartCount");

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.shopping_bag, color: Colors.grey),
                      onPressed: openCart,
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "$cartCount",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
              ),
              const Text(
                "Handpicked For Your Vibe",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _QuickActionCard(
                        title: 'Notifications',
                        subtitle: 'See updates',
                        icon: Iconsax.notification,
                        background: const Color(0xFFFFF4EC),
                        iconColor: const Color(0xFFF97316),
                        onTap: openNotifications,
                      ),
                      _QuickActionCard(
                        title: 'My Bag',
                        subtitle: 'Checkout fast',
                        icon: Iconsax.shopping_bag,
                        background: const Color(0xFFEFF6FF),
                        iconColor: const Color(0xFF2563EB),
                        onTap: openCart,
                      ),
                      _QuickActionCard(
                        title: 'Addresses',
                        subtitle: 'Update location',
                        icon: Iconsax.location,
                        background: const Color(0xFFF0FDF4),
                        iconColor: const Color(0xFF22C55E),
                        onTap: openAddresses,
                      ),
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: SearchForm(),
              ),
              const Categories(),
              const SizedBox(height: defaultPadding),

              // Recent Views section: only sold T-shirts
              Container(
                key: _recentKey,
                padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Views', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () {
                            // scroll to trending as a quick action
                            _scrollToKey(_trendingKey);
                          },
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    SizedBox(
                      height: 190,
                      child: _soldTshirts.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _soldTshirts.length,
                              itemBuilder: (context, index) {
                                return _buildProductCard(_soldTshirts[index]);
                              },
                            )
                          : const Center(child: Text('No recently viewed T-shirts')),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: defaultPadding),

              // Trending section: only sold T-shirts (as requested)
              Container(
                key: _trendingKey,
                padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Trending', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () {
                            // maybe open a page with all trending
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Open full Trending list')),
                            );
                          },
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    SizedBox(
                      height: 190,
                      child: _soldTshirts.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _soldTshirts.length,
                              itemBuilder: (context, index) {
                                return _buildProductCard(_soldTshirts[index]);
                              },
                            )
                          : const Center(child: Text('No trending T-shirts')),
                    ),
                  ],
                ),
              ),

              // New arrivals (kept as before)
              const SizedBox(height: defaultPadding),
              const NewArrivalProducts(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerStat extends StatelessWidget {
  const _DrawerStat({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
