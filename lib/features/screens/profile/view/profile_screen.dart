import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';
import 'package:shop/features/controllers/order/order_controller.dart';
import 'package:shop/features/screens/favorite/view/favorite_screen.dart';
import 'package:shop/features/screens/orders/view/order_list.dart';
import 'package:shop/utils/responsive/responsive.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderController = Provider.of<OrderController>(
        context,
        listen: false,
      );
      orderController.myOrders();
      final controller = Provider.of<UserController>(context, listen: false);
      controller.fetchUser();
    });
  }

  String _safeString(dynamic value) {
    try {
      if (value == null) return '';
      return value.toString();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    print('');
    return Consumer2<UserController, OrderController>(

      builder: (context, controller, orderController, child) {
        // Use safe accessors and provide demo/fallback values when data is not available.
        final dynamic user = controller.user;
        final String userName = _safeString(user?.name).isNotEmpty
            ? _safeString(user?.name)
            : 'Guest User';
        final String userEmail = _safeString(user?.email).isNotEmpty
            ? _safeString(user?.email)
            : 'No email provided';
        final String profilePic = _safeString(user?.profilePic);
        final int ordersCount = orderController.orders?.length ?? 0;

        // Instead of showing a full-screen loader when user is null, show the page with demo/fallback data.
        // This avoids leaving the user staring at a loader indefinitely when no data comes back.
        return Scaffold(

          backgroundColor: Colors.grey[50],
          // Sticky logout button placed here so it is always visible and properly positioned
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.only(
              left: responsive.spacing(16),
              right: responsive.spacing(16),
              bottom: responsive.spacing(8),
            ),
            child: _buildStickyLogoutButton(responsive),
          ),
          body: CustomScrollView(
            slivers: [
              // App Bar with Profile Header
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: responsive.heightPercent(40),
                pinned: true,
                backgroundColor: const Color(0xFF3B82F6),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF3B82F6),
                          Color(0xFF2563EB),
                          Color(0xFF1D4ED8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveSizedBox(height: 20),
                          // Profile Image (handles null user/profilePic internally)
                          _buildProfileImage(controller, profilePic, responsive),
                          ResponsiveSizedBox(height: 16),
                          // User Name
                          ResponsiveText(
                            userName,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          ResponsiveSizedBox(height: 4),
                          // Email
                          ResponsiveText(
                            userEmail,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          ResponsiveSizedBox(height: 16),
                          // Stats Row
                          _buildStatsRow(orderController, responsive, ordersCount),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile Options
              SliverToBoxAdapter(
                child: ResponsivePadding(
                  all: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Section
                      _buildSectionTitle('Account', responsive),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, [
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your information',
                          color: const Color(0xFF3B82F6),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.location_on_outlined,
                          title: 'Addresses',
                          subtitle: 'Manage shipping addresses',
                          color: const Color(0xFFEC4899),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.payment_outlined,
                          title: 'Payment Methods',
                          subtitle: 'Manage your cards',
                          color: const Color(0xFF8B5CF6),
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Orders Section
                      _buildSectionTitle('Orders', responsive),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, [
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.shopping_bag_outlined,
                          title: 'My Orders',
                          subtitle: ordersCount > 0
                              ? 'You have $ordersCount orders'
                              : 'No orders yet',
                          color: const Color(0xFF10B981),
                          onTap: () => Get.to(() => OrderListScreen()),
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.favorite_outline,
                          title: 'Wishlist',
                          subtitle: 'Your saved items',
                          color: const Color(0xFFEF4444),
                          onTap: () => Get.to(() => FavoriteScreen()),
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.star_outline,
                          title: 'Reviews',
                          subtitle: 'Your product reviews',
                          color: const Color(0xFFF59E0B),
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Settings Section
                      _buildSectionTitle('Settings', responsive),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, [
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage notification preferences',
                          color: const Color(0xFF6366F1),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.language_outlined,
                          title: 'Language',
                          subtitle: 'English (US)',
                          color: const Color(0xFF14B8A6),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          subtitle: 'Switch theme appearance',
                          color: const Color(0xFF64748B),
                          onTap: () {},
                          trailing: Switch(
                            value: false,
                            onChanged: (value) {},
                            activeColor: const Color(0xFF3B82F6),
                          ),
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Support Section
                      _buildSectionTitle('Support', responsive),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, [
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.help_outline,
                          title: 'Help Center',
                          subtitle: 'FAQs and support',
                          color: const Color(0xFF06B6D4),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'View our privacy policy',
                          color: const Color(0xFF84CC16),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          subtitle: 'View terms of service',
                          color: const Color(0xFFA855F7),
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: 16),

                      // Previously the logout button was placed here which could be clipped or not visible on some devices.
                      // We moved the actual interactive logout control into the scaffold's bottomNavigationBar to
                      // ensure it's always visible above system UI (safe area) and consistently sized.
                      // Keep a spacer so content doesn't butt up against the bottom button.
                      ResponsiveSizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyLogoutButton(ResponsiveUtils responsive) {
    // The sticky logout button is placed in the scaffold's bottomNavigationBar inside a SafeArea.
    // It uses a Consumer to access the UserController and shows a confirmation dialog before logging out.
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return SizedBox(
          height: responsive.spacing(56),
          child: Material(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  // call logout on the controller
                  userController.logout(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      blurRadius: responsive.spacing(12),
                      offset: Offset(0, responsive.spacing(6)),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: responsive.iconSize(20),
                      ),
                      SizedBox(width: responsive.spacing(8)),
                      ResponsiveText(
                        'Logout',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(
      UserController controller,
      String? profilePic,
      ResponsiveUtils responsive,
      ) {
    final imageSize = responsive.spacing(100);
    final iconSize = responsive.iconSize(16);

    // Provide a fallback image URL when profilePic is empty.
    const fallbackImageUrl =
        'https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D';

    return Stack(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: responsive.spacing(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: responsive.spacing(20),
                offset: Offset(0, responsive.spacing(10)),
              ),
            ],
          ),
          child: ClipOval(
            child: controller.isUpdatingPhoto
                ? ShimmerEffect(
              width: imageSize,
              height: imageSize,
              radius: imageSize / 2,
            )
                : controller.selectedImage != null
                ? Image.file(
              controller.selectedImage!,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            )
                : (profilePic != null && profilePic.isNotEmpty)
                ? Image.network(
              profilePic,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  fallbackImageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.network(
              fallbackImageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () => controller.updateProfilePhoto(context),
            child: Container(
              padding: EdgeInsets.all(responsive.spacing(4)),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: responsive.spacing(2),
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
      OrderController orderController,
      ResponsiveUtils responsive,
      int ordersCount,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.spacing(40)),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(24),
        vertical: responsive.spacing(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Orders',
            '$ordersCount',
            responsive,
          ),
          Container(
            height: responsive.spacing(30),
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('Wishlist', '12', responsive),
          Container(
            height: responsive.spacing(30),
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('Reviews', '8', responsive),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label,
      String value,
      ResponsiveUtils responsive,
      ) {
    return Column(
      children: [
        ResponsiveText(
          value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ResponsiveSizedBox(height: 2),
        ResponsiveText(
          label,
          fontSize: 12,
          color: Colors.white.withOpacity(0.9),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ResponsiveUtils responsive) {
    return ResponsivePadding(
      left: 4,
      child: ResponsiveText(
        title,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildOptionCard(ResponsiveUtils responsive, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOption({
    required ResponsiveUtils responsive,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    final iconContainerSize = responsive.spacing(48);
    final iconSizeValue = responsive.iconSize(24);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        child: Padding(
          padding: responsive.padding(all: 16),
          child: Row(
            children: [
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(12),
                  ),
                ),
                child: Icon(icon, color: color, size: iconSizeValue),
              ),
              SizedBox(width: responsive.spacing(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    ResponsiveSizedBox(height: 2),
                    ResponsiveText(
                      subtitle,
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: responsive.iconSize(24),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
