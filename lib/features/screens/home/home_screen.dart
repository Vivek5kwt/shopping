import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
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
    final Color statusColor = theme.scaffoldBackgroundColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.black12,
                      child: Icon(Iconsax.shop, size: 28),
                    ),
                    const SizedBox(width: defaultPadding / 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Welcome!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Your personalized store', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Recent View'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  // Scroll to recent section
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
                leading: const Icon(Icons.checkroom),
                title: const Text('Sold T-Shirts'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  Future.microtask(() => _scrollToKey(_trendingKey));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
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
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Notifications'),
                      content: const Text('You have new notifications.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Example action
                          Navigator.of(context).maybePop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('View all orders tapped')),
                          );
                        },
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('My Orders'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              // Open drawer reliably
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset("assets/icons/menu.svg"),
          );
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/Location.svg"),
            const SizedBox(width: defaultPadding / 2),
            Text(
              "15/2 New Texas",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          // Notification icon with badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.grey),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Notifications'),
                      content: const Text('You have some recent updates.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
                      ],
                    ),
                  );
                },
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
                    onPressed: () {},
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
